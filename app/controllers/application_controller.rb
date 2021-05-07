class ApplicationController < ActionController::Base
  # before_action :configure_permitted_parameters, if: :devise_controller?
  # protected
  #
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :given_name,:family_name,:terms_and_conditions,:accepted_privacy,:should_receive_ce_updates,
  #                                                      :profile, :password, :password_confirmation,:can_represent_company,company_attributes:[:name,:industry_id,:email],
  #                                                      address_attributes:[:address_line_1,:country_id,:address_line_2,:city,:postal_code]])
  # end
end
