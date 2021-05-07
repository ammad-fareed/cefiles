class Admin::ProductsController < Admin::ApplicationController
  skip_load_resource only: [ :create, :autocomplete_product_company_name ]
  load_and_authorize_resource
  before_action :check_plan_limit,only: [:new,:create],:unless => :is_admin?
  before_action :prevent_draft_to_publish,only: :update,:unless => :is_admin?
  def index
    @q = current_user.admin?? Product.ransack(params[:q]) : current_user.company.products.ransack(params[:q])
    @products = @q.result.includes(:company,:product_category).page(params[:page]).per(10)

  end

  def show
    @product=Product.find(params[:id])
  end

  def new
    # Prepopulate the supplier details with the company details - only applicable for company users because
    # admins can select any company to assign the product to
    unless current_user.admin?
      supplier = @product.build_supplier
      supplier.name = current_user.company.name
      supplier.address = current_user.company.address
      supplier.address.id = nil
    end
    build_product_associations
  end

  def create
    if params[:copy_supplier_to_manufacturer].present?
      params[:product][:manufacturer_attributes] = params[:product][:supplier_attributes]
    end
    @product = current_user.admin?? Product.new(product_params) : current_user.company.products.new(product_params)
    if !@product.valid?
      build_product_associations
      flash[:alert] = I18n.t('flash.actions.create.alert', resource_name: @product.class)
      render :new
    else
      if current_user.admin?
        @product.is_imported=false
        @product.searchable=true
        @product.approve!
        @product.save
        redirect_to admin_product_path(@product.id)
      else
        @product.is_imported=false
        @product.approve!
        @product.save
        redirect_to admin_product_path(@product.id)
      end
    end



  end

  def edit
    build_product_associations
    get_qr_code
  end

  def update

    @product.update_attributes(product_params)
    if @product.valid?
      flash[:success]="Product successfully updated"
      redirect_to admin_product_path(@product)
    else
      build_product_associations
      flash[:alert] = I18n.t('flash.actions.update.alert', resource_name: @product.class)
      get_qr_code
      render :edit
    end
  end

  def approve_product
    @product=Product.find(params[:id])
    @product.update_attribute(:searchable,true)
    @product.approve!
    flash[:notice]='Product successfully approved'
    redirect_to pending_approval_admin_products_path
  end

  def reject_product
    @product=Product.find(params[:id])
    @product.reject!
    flash[:notice]='Product rejected'
    redirect_to pending_approval_admin_products_path
  end

  def remarks_create
    @product=Product.find(params[:id])
    @product.reject!
    @remarks = @product.build_product_remark(params[:product_remark])
    if @remarks.save
      @user = @product.company.users.first
      EnquiryMailer.reject_notification(@user,@product).deliver
    end
  end
  def product_remarks
    @product=Product.find(params[:id])
    @remarks=@product.build_product_remark
  end

  def autocomplete_product_company_name
    @products  = Product.accessible_by(current_ability).where("name ILIKE ?", "%#{params[:term]}%")
    @companies = Company.accessible_by(current_ability).where("name ILIKE ?", "%#{params[:term]}%")
    render json: @products.map(&:name) + @companies.map(&:name)
  end

  def countries
    render layout: 'empty'
  end

  private
  def get_qr_code
    product_url = Rails.env=='production' ? "https://cefiles-staging-new.herokuapp.com/products/#{params[:id]}" : "http://localhost/products/#{params[:id]}"
    qrcode = RQRCode::QRCode.new(product_url)
    @svg = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 8,
      standalone: true
    )
  end
  def product_params
    params.require(:product).permit(:name, :company_id,:published,:model_number,:product_category_id,:image,:description,:notes,
                                    :sales_rep_check,:remove_image,:image_cache,
                                    all_suppliers_attributes:[:id,:name,:email,:phone,:_destroy,
                                                              address_attributes:[:id,:address_line_1,:city,:state,:postal_code,:country_id]
                                    ])
  end
  def is_admin?
    current_user.admin?
  end
  def check_plan_limit
    if(current_user.company.plan_name.blank?)
      redirect_to plans_path
      flash[:notice] = "Please subscribe to silver or gold plan to publish your products"
    elsif  current_user.company.unsubscription_date_reached?
      redirect_to admin_products_path
      flash[:notice] = "Your plan subscription has been ended. Please resubscribe again to add more products"
    elsif ((current_user.company.silver_plan_limit_reached?) || (current_user.company.gold_plan_limit_reached?))
      redirect_to admin_products_path
      flash[:notice] = "You have been reached current month limit of adding the products"
    elsif (current_user.company.subscription_status=='cancelled' || current_user.company.subscription_status=='deleted')
      flash[:notice] ="Please subscribe again to publish the products"
      redirect_to admin_products_path
    end
  end
  def build_product_associations
    @product.all_suppliers.build.build_address unless @product.all_suppliers.present?
    @product.build_manufacturer.build_address unless @product.manufacturer.present?
    @product.build_eu_representative.build_address unless @product.eu_representative.present?
  end
  def prevent_draft_to_publish
    product = current_user.company.products.find(params[:id])
    if current_user.company.unsubscription_date_reached?
      redirect_to admin_products_path
      flash[:notice] = "Please resubscribe again to publish your products"
    elsif((current_user.company.silver_plan_limit_reached? || current_user.company.gold_plan_limit_reached?) && !product.published && params[:product][:published]=='1' )
      flash[:notice] = "You have been reached current month limit of adding the published products. However you can update draft products"
      render :edit
    elsif (current_user.company.subscription_status=='cancelled' || current_user.company.subscription_status=='deleted')
      flash[:notice] = "Please subscribe again to publish the products"
      redirect_to admin_products_path
    end
  end
end
