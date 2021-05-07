class User::RegistrationsController < Devise::RegistrationsController
  # invisible_captcha only: [:create], on_spam: :honeypoted_spam_entry
  before_action :check_black_listed, only: :create
  # before_action :configure_sign_up_params, only: [:create]


  def new
    self.resource = UserRegistration.new
    resource.build_company.build_address
    session.delete(:plan_id)
    (@plan_id=params[:plan_id];session[:plan_id]=params[:plan_id]) if params[:plan_id].present?
    respond_with resource
  end

  def create
    self.resource = UserRegistration.new(sign_up_params)
    recaptcha_valid = verify_recaptcha(model: resource)
    if !recaptcha_valid
      flash[:notice] ="Oops! Looks like you are not a human. Please try again by filling out the missing information."
      
      self.resource = UserRegistration.new(sign_up_params)
      resource.build_company unless resource.company
      resource.company.approved = true
      resource.company.build_address unless resource.company.address
      (@plan_id=params[:plan_id];session[:plan_id]=params[:plan_id]) if params[:plan_id].present?
      clean_up_passwords resource
      render :new
    else
      self.resource = UserRegistration.create(sign_up_params)
      if resource.valid? && resource.save
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          session.delete(:plan_id)
          resource.update_attributes(approved: true) if resource.company.selected_plan_id.present?
          resource.company.update_attributes(approved:true,email: resource.email) if resource.company.selected_plan_id.present?
          redirect_to after_sign_up_path_for(resource)

        else
          expire_session_data_after_sign_in!
          redirect_to after_inactive_sign_up_path_for(resource)
        end
      else
        render :new
        # Rebuild all the associations
        resource.build_company unless resource.company
        resource.company.approved = true
        resource.company.build_address unless resource.company.address
        (@plan_id=params[:plan_id];session[:plan_id]=params[:plan_id]) if params[:plan_id].present?
        clean_up_passwords resource

      end
    end


  end

  protected

  def sign_up_params
    params.require(:user).permit(:email, :given_name,:family_name,:terms_and_conditions,:accepted_privacy,:should_receive_ce_updates,
                                 :password, :password_confirmation,:can_represent_company,
                                 company_attributes:[:name,:industry_id,:email,:selected_plan_id,address_attributes:[:address_line_1,:country_id,:address_line_2,:city,:state,:postal_code]],
                                 )
  end
  def after_sign_up_path_for(resource)
    resource.company.plan_id.present? ? subscribe_subscriptions_path : plans_path
  end

  private
  def honeypoted_spam_entry
    redirect_to root_path
  end
  def check_black_listed

    begin
      response = HTTParty.get("http://ip-api.com/json/#{request.remote_ip}")
      parsed = JSON.parse(response.body)
      if (parsed["country"]=="Russia" || parsed["country"]=="Ukraine")
        redirect_to root_path
      end
    rescue => error
      puts("***********ip check error*******")
      puts(error.message)
    end

  end




end