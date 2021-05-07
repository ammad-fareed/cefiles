class PagesController < ApplicationController
  layout "home",only: :home
  def home
    @q=Product.search(params[:q])
  end
  def subscription

  end
  def basic_search
    params[:q]['company_name_or_name_or_model_number_cont'] = params[:q]['company_name_or_name_or_model_number_cont'].split(".")[0]
    @q=Product.published.searchable.admin_approved.order("name ASC").search(params[:q])
    if params[:q].present?
      @products=@q.result.includes(:product_category,:company)
      @products=@products.page(params[:page])
      #return redirect_to product_path(@products.first) if @products.count == 1
    else
      @products=[]
    end
  end
end
