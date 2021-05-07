class Admin::DocumentsController < Admin::ApplicationController
  load_and_authorize_resource :product, only: [:new, :create]
  load_and_authorize_resource except: [:show, :new, :create]

  def show
    # Eager load whodunnit to prevent n+1 requests from view
    @document = Document.includes(:versions).find(params[:id])
    authorize! :read, @document
  end

  def new
    @document = @product.documents.build
    authorize! :create, @document
  end

  def create
    @document = @product.documents.build(docs_params)
    authorize! :create, @document
    if @document.save
    redirect_to admin_product_path(@product)
    else
      flash[:error]= "Error creating document"
      render :new
    end
  end

  def edit
  end

  def update
    @document.update_attributes(docs_params)
    redirect_to admin_document_path(@document)
  end

  def destroy
    @document.destroy
    respond_with @document, location: admin_product_path(@document.product)
  end
  private
  def docs_params
    params.require(:document).permit(:title,:description,:file,:public)
  end
end
