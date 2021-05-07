class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  check_authorization
  layout "admin"
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
private

  def authenticate_admin!
    raise CanCan::AccessDenied unless current_user.admin?
  end

end
