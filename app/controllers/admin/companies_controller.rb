class Admin::CompaniesController < Admin::ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:create]
  # before_action :authenticate_admin!, only: [:index]

  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result.includes(:industry).page(params[:page]).per(10)

    if params[:hide_archived] == 'true'
      @companies = @companies.unarchived.page(params[:page]).per(10)
    end

  end

  def new
    @company.build_address
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to admin_companies_path
    else
      render :new
    end

  end

  def edit
    @company.build_address unless @company.address.present?
  end

  def update
    @company.update_attributes(company_params)
    if @company.valid?
      flash[:notice]="Company successfully updated"
      redirect_to admin_company_path(@company)
    else
      render :edit
    end

  end

  def show
    if current_user.company.customer_id
      @card_details = Stripe::Customer.list_sources(
          current_user.company.customer_id,
          {object: 'card', limit: 5},
          )
      @card_details = @card_details.data.first
    end

  end

  def archive
    @company.update_attribute("archived",true)
    flash[:notice]= "Company has been successfully archived"
    redirect_to admin_company_path(@company)
  end

  def unarchive
    @company.update_attribute("archived",false)
    @company.save
    flash[:notice]= "Product has been unarchived"
    redirect_to admin_company_path(@company)
  end
  def edit_card

  end
  def update_card
    company = current_user.company
    company.card_token=company_params[:card_token]
    if company.update_card_details
      redirect_to admin_company_path(company)
      flash[:notice]='Your card has been successfully updated.'
    else
      redirect_to admin_company_path(company)
      flash[:notice]='Something went wrong while updating card details. Please try again in a few minutes.'
    end
  end
  private
  def company_params
    params.require(:company).permit(:name,:email,:website,:phone_number,:industry_id,:published_product_limit,:card_token,address_attributes:
        [:id,:address_line_1,:country_id,:city,:state,:postal_code])
  end
end
