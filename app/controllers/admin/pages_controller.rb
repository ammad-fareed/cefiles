class Admin::PagesController < Admin::ApplicationController
  before_action :authenticate_user!
  skip_authorization_check
  layout "admin"
  def dashboard
  end
end
