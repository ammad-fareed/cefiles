class SubscriptionsController < ApplicationController
  before_action :authenticate_user!,except: [:plans,:webhook]

  protect_from_forgery except: [:webhook]
  before_action :check_for_company_email_and_prior_plan,only: :create
  before_action :check_gold_published_products, only: :plan_update, :if => proc { current_user.company.plan_name=='Gold' }
  before_action :check_products_before_unsub, only: :cancel_subscription
  # include PlansHelper
  def new

  end

  def create
    plan_id = params[:subscription][:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    current_user.company.card_token=params[:subscription][:card_token]
    stripe_customer = current_user.company.create_or_find_customer

    if stripe_customer[:error].present?
      flash[:alert]=stripe_customer[:error][:message]
      return redirect_to plans_path
    end
    if current_user.company.plan_id==plan_id
      flash[:notice] = "You have already subscribed to this plan"
      redirect_to admin_root_path
    else
      stripe_subscription = stripe_customer.subscriptions.create(:plan => plan.id)
      current_user.company.update_attributes(plan_id:stripe_subscription.plan.id,subscription_id: stripe_subscription.id,
                                             plan_name:stripe_subscription.plan.nickname,current_period_start:Time.at(stripe_subscription.current_period_start),
                                             current_period_end: Time.at(stripe_subscription.current_period_end))
      flash[:notice] = "You have successfully subscribed to #{plan.nickname} plan."
      redirect_to admin_root_path
    end
  end
  def cancel_subscription
    current_user.company.new_plan_id = params[:p_id]
    if current_user.company.unsubscribe
      flash[:notice]='You have successfully unsubscribed the plan.'
      redirect_to admin_root_path
    else
      flash[:notice] = 'Something went wrong while unsubscribing the plan. Please try again in a moment.'
      redirect_to plans_path
    end
  end
  def resubscribe
    if current_user.company.resubscribe
      flash[:notice]='You have successfully re subscribed the plan.'
      redirect_to admin_root_path
    else
      flash[:notice] = 'Something went wrong while unsubscribing the plan. Please try again in a moment.'
      redirect_to plans_path
    end
  end
  def subscribe
    @stripe_list = Stripe::Plan.list
    @plan = @stripe_list[:data].map{|p| p if p.id==current_user.company.selected_plan_id}.compact.first

  end
  def sign_out_free_user
    sign_out(current_user)
    redirect_to root_path
    flash[:notice] = "You have to confirm your account before continuing."
  end
  def plans
    @stripe_list = Stripe::Plan.list
    @plans = @stripe_list[:data].select{|d| d if d.active==true}

  end

  def plan_update
    current_user.company.new_plan_id = params[:p_id]
    if current_user.company.update_plan
      flash[:notice] = "Your plan has been successfully changed to #{current_user.company.plan_name}"
      redirect_to admin_root_path
    else
      flash[:error] = "Ooops! something went wrong while changing your plan. Please try again later"
      redirect_to admin_root_path
    end
  end

  def webhook
    begin
      event_type = params.dig("type")
      event_object = params['data']['object']
      company = retrieve_company
      #refer event types here https://stripe.com/docs/api#event_types

      case event_type
      when 'invoice.payment_succeeded'
        company.renew_subscription
      when 'invoice.payment_failed'
        company.update_payment_failure(event_object["attempt_count"])
      end
    rescue Exception => ex
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end
    render :json => {:status => 200}

  end

  private
  def check_products_before_unsub
    current_user.company.new_plan_id = params[:p_id]
    if current_user.company.plan_limit > 0
      flash[:notice] ='Please unpublish products before unsubscribing the plan'
      redirect_to admin_products_path
    elsif !current_user.company.unsubscribing_same_plan
      flash[:error] ='You are trying to unsubscribe different plan from your current subscribed plan'
      redirect_to plans_path
    end
  end
  def check_gold_published_products
    if current_user.company.before_plan_update_count > 10
      redirect_to admin_root_path
      flash[:notice]='Please reduce the number of published products to 10 before downgrading your plan'
    end
  end
  def retrieve_company
    token = params.dig("data","object","customer")
    Company.find_by_customer_id(token)
  end
  def check_for_company_email_and_prior_plan
    if current_user.company.email.blank?
      flash[:notice]='Please add company email before subscribing to any plan'
      redirect_to admin_company_path(current_user.company.id)
    elsif current_user.company.plan_id.present?
      flash[:error] = "You already have an active susbscription plan. Please unsubscribe before proceeding to other plan."
      redirect_to admin_root_path
    elsif current_user.company.plan_name.present? && current_user.company.plan_name == "Gold" && current_user.company.before_plan_update_count > 10
      flash[:error] = "Please reduce the number of publisehd products to 10 before downgrading your plan"
      redirect_to admin_root_path
    end
  end
end
