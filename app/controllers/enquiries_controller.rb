class EnquiriesController < ApplicationController
  # invisible_captcha only: [:create], on_spam: :honeypoted_spam_entry

  def new
    @enquiry = Enquiry.new(name: current_user.try(:display_name), email: current_user.try(:email))
  end

  def create
    @enquiry = Enquiry.new(enquiry_params)
    recaptcha_valid = verify_recaptcha(model: @enquiry)
    if recaptcha_valid
      @enquiry.user = current_user if current_user.present?
      if @enquiry.save
        redirect_to contact_thanks_path
      else
        render :new
      end

    else
      flash[:alert] ="Oops! Looks like you are not a human. Please try again."
      render :new
    end
  end
  private
  def enquiry_params
    params.require(:enquiry).permit(:name,:email,:user_id,:content)
  end
  def honeypoted_spam_entry
    redirect_to root_path
  end
end
