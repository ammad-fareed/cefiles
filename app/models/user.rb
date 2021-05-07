class User < ApplicationRecord
  # Include default devise partials. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:trackable
  validates :password, password_strength: true,:if => Proc.new {|u| u.password.present?}
  # Include default devise partials. Others available are:
  attr_accessor :terms_and_conditions,:can_represent_company
  validates_format_of :email,
                      :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,multiline:true
  belongs_to :company, dependent: :destroy
  accepts_nested_attributes_for :company
  has_many :enquiries
  # validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates_presence_of :given_name,:family_name
  validates_presence_of :accepted_privacy,on: :create
  scope :search_by_term, lambda {  |term| where('given_name ILIKE :term OR family_name ILIKE :term OR users.email ILIKE :term ', term: "%#{term}%") }
  scope :unarchived, lambda { where(archived: false) }
  scope :approved, lambda { where(approved: true) }
  scope :pending_approval, lambda { where(approved: nil) }
  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
                                    Arel::Nodes::InfixOperation.new('||',
                                                                    parent.table[:given_name], Arel::Nodes.build_quoted(' ')
                                    ),
                                    parent.table[:family_name]
    )
  end
  def display_name
    I18n.t('user.display_name', given_name: given_name, family_name: family_name)
  end

  def admin?
    company_id && company.admin?
  end

  # def active_for_authentication?
  #   super && approved? && !archived?
  # end

  # # The message to display for invalid logins
  # def inactive_message
  #   if archived?
  #     :archived
  #   elsif approved == false
  #     :rejected
  #   else
  #     super
  #   end
  # end

  def role
    admin? ? :admin : :default
  end

  alias_method :to_s, :display_name

  def self.sort_order(column, direction)
    if column == 'name'
      sort = "family_name #{direction}, given_name"
    elsif column == 'company'
      sort = "companies.name"
    elsif column_names.include?(column)
      sort = column
    else
      sort = "family_name #{direction}, given_name"
    end

    "#{sort} #{direction}"
  end

  def approve!
    self.approved = true
    self.company.approved = true
    save
  end

  def reject!
    self.approved = false
    self.company.approved = false if company.approved.nil?
    save
  end

  def rejected?
    approved == false
  end




  def active_for_authentication?
    super && !self.company.deactivated && !self.archived?
  end
  def inactive_message
    if self.company.deactivated?
      'Your account has been disabled due to non payment'
    elsif archived?
      :archived
    else
      super
    end
  end
end
