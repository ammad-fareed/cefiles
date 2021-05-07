class UserRegistration < User
  # attr_accessible :company_id, :terms_and_conditions, :can_represent_company, :company_attributes, :accepted_privacy,:should_receive_ce_updates
  attr_accessor :can_represent_company,:terms_and_conditions
  validates_acceptance_of :terms_and_conditions
  validates_acceptance_of :can_represent_company, if: :new_company?
  validate :correct_company_errors

  accepts_nested_attributes_for :company #, reject_if: :nested_attributes_blank?

private

  def nested_attributes_blank?(attributes)
    persisted? || (attributes['address_attributes'].values.uniq == [''] && attributes.select{ |k,v| k != 'address_attributes'}.values.uniq == [''])
  end

  def correct_company_errors
    errors.delete(:company_id) if company.present?
  end

  def new_company?
    company.present? && company.new_record?
  end
end