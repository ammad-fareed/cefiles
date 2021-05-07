class ProductsController < ApplicationController
  def show
    if params[:code].present?
      @product = Product.where(share_code: params[:code]).find(params[:id])
    else
      if @product = Product.published.find(params[:id])
      else
        redirect_to search_products_path
      end
    end
    # render layout: 'product'
  end

  def search
    params[:q].present? && params[:q]['company_name_matches'].present? ? params[:q]['company_name_matches']= params[:q]['company_name_matches'].split(".")[0] : params[:q]
    @q=Product.published.imported.admin_approved.search(params[:q])
    if params[:q].present?
      @products=@q.result.includes(:product_category,:company).order("companies.name ASC,products.name ASC")
      #return redirect_to product_path(@products.first) if @products.count == 1
      @products=@products.page(params[:page]).per(10)
    else
      @products=[]
    end
  end

  def get_products_count
    @products=ProductCategory.find(params[:category_id]).try(:products).published.imported.admin_approved.count rescue false
    render json: @products
  end

  def sellect_contact
    @product=Product.find(params[:id])
  end

  def seller_popup
    @supplier=Supplier.find(params[:seller_id].to_i)
    @product=Product.find(params[:product_id].to_i)
    @comment = params[:comment].to_s
    if @product.is_imported == true
      EnquiryMailer.emailsend_seller(@supplier,@product,@comment).deliver
      flash[:notice] = "Email successfully deliver"
      redirect_to(:back)
    else
      redirect_to(:back)
    end
  end
end
