class CompanyMailer < ApplicationMailer
  def notify_company_on_payment_failure(company)
    @email = "abidiqbal4u@gmail.com"
    mail(to: @email, from: 'noreply@cefiles.com', subject: "Your Cefiles Monthly Subscription Has been Canceled")
  end
end
