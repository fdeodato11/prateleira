module Admin
  class ProductsController < BaseController
    before_action :set_product, only: %i[show edit update destroy restore]

    def index
      @products = Product.with_discarded
        .includes(:category)
        .search(params[:query])
        .by_category(params[:category_id])
        .by_status(params[:status])
        .ordered

      @pagy, @products = pagy(@products, items: 20)
      authorize @products
    end

    def show
      authorize @product
    end

    def new
      @product = Product.new
      authorize @product
    end

    def create
      @product = Product.new(product_params)
      authorize @product

      if @product.save
        redirect_to admin_products_path, notice: t(".notice")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @product
    end

    def update
      authorize @product

      if @product.update(product_params)
        redirect_to admin_products_path, notice: t(".notice")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @product
      @product.discard!
      redirect_to admin_products_path, notice: t(".notice")
    end

    def restore
      authorize @product, :restore?
      @product.undiscard!
      redirect_to admin_products_path, notice: t(".notice")
    end

    private

    def set_product
      @product = Product.with_discarded.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :category_id, :name, :description, :price, :stock_quantity,
        :sku, :status, :featured, :weight, :image, :tags
      )
    end
  end
end
