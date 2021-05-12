class Admin::UsersController < Admin::ApplicationController

  load_and_authorize_resource except: [:create, :update, :pending_approval]
  skip_authorization_check only: [:show]

  def index

    @q = current_user.admin? ? User.ransack(params[:q]) : current_user.company.users.ransack(params[:q])
    @users = @q.result.includes(:company).page(params[:page]).per(10)

    if params[:hide_archived] == 'true'
      @users = @users.unarchived.page(params[:page]).per(10)
    end

  end

  def show
    @user = User.find(params[:id])

  end

  def new
    @user = User.new
  end

  def create
    authorize! :create, User
    @user = User.new(user_params)
    @user.accepted_privacy = true
    if @user.save
      @user.approve!
      EnquiryMailer.with(user:@user).notify_admin_created_user.deliver_now
      redirect_to [:admin, @user]
    else
      render :new
    end

  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    # If the password fields were not filled, do not update the password
    if user_params[:password].empty? && user_params[:password_confirmation].empty?
      @user.update_attributes(user_params.except(:password,:password_confirmation))
    elsif @user.update_attributes(user_params)
    else
      render :edit
      return
    end



    # Devise will log the current user out when their password is changed, so sign them back in
    # see https://github.com/plataformatec/devise/issues/971
    if ((@user.valid? && current_user == @user) || @user.admin?)
      sign_in(@user, bypass: true)
    end

    redirect_to [:admin, @user]
  end

  def archive
    @user.archived = true
    @user.save
    flash[:notice]="User successfully archived"
    redirect_to admin_user_path(@user)
  end

  def unarchive
    @user.archived = false
    @user.save
    redirect_to admin_user_path(@user)
  end

  def pending_approval
    authorize! :approve, User
    @users = User.accessible_by(current_ability).pending_approval.page(params[:page])
  end

  def approve
    @user.approve!
    respond_with @user, location: pending_approval_admin_users_path
  end

  def reject
    @user.reject!
    respond_with @user, location: pending_approval_admin_users_path
  end
  private
  def user_params
    params.require(:user).permit(:given_name,:archived,:family_name,:email,:company_id,:password,:password_confirmation)
  end
end
