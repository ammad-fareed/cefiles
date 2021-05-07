class EnquiryMailer < ApplicationMailer
  def submit_enquiry
    @enquiry = params[:enquiry]
    mail(to: 'admin@cefiles.com', from: 'noreply@cefiles.com', subject: 'New enquiry from CE files website')
  end

  def emailsend_seller(sup,pro,com)
    @email = sup.email
    @proname = pro.name
    @supname = sup.name
    @comment = com.to_s
    mail(to: "#{@email}", from: 'noreply@cefiles.com', subject: "Product #{@proname}",template_path: 'mailers',template_name: 'emailsend_seller')
  end
  def reject_notification(user,product)
    @username = user.email
    @product = product.name
    @productmodel_No = product.model_number
    @productmodel_number=product.id
    @comment = product.product_remark
    mail(to: "#{@username}", from: 'noreply@cefiles.com', subject: "Your product #{@product}",template_path: 'mailers',template_name: 'reject_notification' )
  end
  def notify_admin_created_user
    @user = params[:user]
    @email = @user.email
    mail(to: @email, from: 'noreply@cefiles.com', subject: "You have been added to cefiles" )
  end
end
