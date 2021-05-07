class Company < ApplicationRecord
  # attr_accessible :address_attributes, :email, :industry_id, :name, :phone_number, :website,:c_xml_id, :card_token,:plan_name,:plan_id,
  #                 :subscription_id,:new_plan_id,:current_period_start,:current_period_end,:stripe_charge_error,:deactivated,:selected_plan_id,
  #                 :plan_updated_to,:plan_updated_from,:plan_update_date,:subscription_status,:unsubscribed_at,:approved, as: [:default, :admin]
  # attr_accessible :published_product_limit, as: [:admin]

  validates :name,  :industry_id, :address, presence: true


  has_many :users, dependent: :destroy
  has_many :products, dependent: :destroy
  belongs_to :address, dependent: :destroy
  belongs_to :industry
  accepts_nested_attributes_for :address
  attr_accessor :card_token,:new_plan_id
  scope :search_by_name, lambda { |name| where('companies.name ILIKE ?', "%#{name}%") }
  scope :unarchived, lambda { where(archived: false) }
  scope :approved, lambda { where(approved: true) }
  scope :alphabetical_order,lambda{where('archived=?',false).order('name ASC')}
  def to_s
    name
  end

  def unarchived?
    !archived?
  end

  def exceeds_published_product_limit?
    products.published.count >= published_product_limit
  end

  def self.sort_order(column, direction)
    if column == 'industry'
      sort = 'industries.name'
    elsif column_names.include?(column)
      sort = column
    else
      sort = 'name'
    end

    "#{sort} #{direction}"
  end

  def rejected?
    approved == false
  end

  def create_or_find_customer
    if self.customer_id.blank?
      begin
        customer = Stripe::Customer.create(
            :description => "User with email #{self.email} has been created for subscription",
            :source => self.card_token,
            :email => self.email
        )
      rescue Stripe::CardError => e
        puts "Something went wrong while subscription.#{e}"
        body = e.json_body
        return body
      end
      self.update_attribute("customer_id",customer.id) if customer.present?
      return customer
    else
      return customer=Stripe::Customer.retrieve(self.customer_id)
    end
  end
  def update_plan
    subscription = Stripe::Subscription.retrieve(self.subscription_id)
    items = [{
                 id: subscription.items.data[0].id,
                 plan: self.new_plan_id, # Switch to new plan
             }]
    update_subscription= Stripe::Subscription.update(
        subscription.id,
        {
            proration_behavior: 'none',
            # billing_cycle_anchor:"now",
            cancel_at_period_end: false,
            items: items,
        }
    )

    if update_subscription.present?
      prev_plan = self.plan_name
      updated_plan = update_subscription.plan.nickname
      self.update_attributes(subscription_status:"active",plan_updated_to:updated_plan, plan_updated_from: prev_plan,plan_update_date:DateTime.now , plan_name:updated_plan,plan_id:update_subscription.plan.id)
      return true
    else
      return false
    end
  end
  def unsubscribe
    begin
      unsubcribe = Stripe::Subscription.update(
          self.subscription_id,
          {
              cancel_at_period_end: true,
          }
      )
      if unsubcribe
        self.update_attributes(subscription_status:"cancelled",unsubscribed_at: DateTime.now)
        return true
      end
    rescue Stripe::CardError => e
      puts "Something went wrong while canceling subscription.#{e}"
      body = e.json_body
      return body
    end

  end
  def cancel_subscription
    begin
      cancel_subscription = Stripe::Subscription.delete(self.subscription_id)
      if cancel_subscription.status == 'canceled'
        self.update_attributes(subscription_status:"deleted",unsubscribed_at: DateTime.now,plan_name:nil,plan_id:nil,subscription_id:nil)
        CompanyMailer.notify_company_on_payment_failure(self).deliver
      end
    rescue Stripe::CardError => e
      puts "Something went wrong while canceling subscription.#{e}"
      body = e.json_body
      return body
    end
  end

  def resubscribe
    begin
      resubscription = Stripe::Subscription.update(
          self.subscription_id,
          {
              cancel_at_period_end: false,
          }
      )
      if resubscription
        self.update_attributes(subscription_status:"active")
        return true
      end
    rescue Stripe::CardError => e
      puts "Something went wrong while re subscription.#{e}"
      body = e.json_body
      return body
    end

  end
  def renew_subscription
    self.update_attributes(current_period_start:Date.today, current_period_end: Date.today + 1.month,stripe_charge_error:nil)
  end
  def update_payment_failure(attempt_count)
    self.update_attributes(stripe_charge_error:"Monthly invoice payment failed")
    self.cancel_subscription_and_unpublish_products if attempt_count == 4 #attempt count is the no of tries that stripe does to charge monthly payment within a week
  end
  def plan_limit
    start_date = self.try(:current_period_start).try(:to_datetime)
    end_date = self.try(:current_period_end).try(:to_datetime)
    self.products.published.period_limit_products(start_date,end_date).count
  end
  def silver_plan_limit_reached?
    self.plan_name=="Silver" && plan_limit >= 10
  end
  def gold_plan_limit_reached?
    self.plan_name=="Gold" && plan_limit >= 20
  end

  def unsubscription_date_reached?
    (self.subscription_status == 'cancelled' || self.subscription_status == 'deleted') && DateTime.now >= self.current_period_end.to_datetime
  end
  def unsubscribe_date_not_reached?
    (self.subscription_status == 'cancelled' || self.subscription_status == 'deleted') && self.current_period_end.to_datetime > DateTime.now
  end
  def before_plan_update_count
    start_date = self.try(:current_period_start).try(:to_datetime)
    end_date = self.try(:current_period_end).try(:to_datetime)
    self.products.published.period_limit_products(start_date,end_date).count
  end
  def update_card_details
    customer = Stripe::Customer.retrieve(self.customer_id)
    card = customer.sources.create(card: self.card_token)
    card.save
    customer.default_source = card.id
    customer.save
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating card info: #{e.message}"
    self.update_attribute("stripe_charge_error",e.message);
    false
  end
  def cancel_subscription_and_unpublish_products
    self.products.published.each{ |p| p.update_attributes(published:false)}
    self.cancel_subscription

  end
  def plan_period_ended_non_payment
    self.current_period_end.to_datetime < DateTime.now && self.subscription_status=='deleted'
  end
  def plan_period_ended_unsubscribed
    self.current_period_end.to_datetime < DateTime.now && self.subscription_status=='cancelled'
  end
  def unsubscribing_same_plan
    begin
      subscription  =  Stripe::Subscription.retrieve(self.subscription_id)
      present_plan_id = subscription.items.data.first.plan.id
      if self.new_plan_id == present_plan_id
        return true
      else
        return false
      end
    rescue Stripe::CardError => e
      puts "Something went wrong while subscription checking.#{e}"
      body = e.json_body
      return body
    end

  end
end
