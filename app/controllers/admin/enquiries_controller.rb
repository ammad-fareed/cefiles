class Admin::EnquiriesController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @q=Enquiry.ransack(params[:q])
    @enquiries = @q.result.page(params[:page]).per(10)
  end

  def show
  end
end
