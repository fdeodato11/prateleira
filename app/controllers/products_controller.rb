class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  def index
    @products = Product.kept.active
      .includes(:category)
      .search(params[:query])
      .by_category(params[:category_id])
      .by_price_range(params[:price_min], params[:price_max])
      .by_status(params[:status])
      .ordered

    @products = sort_products(@products)
    @pagy, @products = pagy(@products, items: 12)

    @categories = Category.kept.ordered
  end

  def show
    @product = Product.kept.active.includes(:category).find(params[:id])
  end

  private

  def sort_products(products)
    case params[:sort]
    when "price_asc"  then products.reorder(price: :asc)
    when "price_desc" then products.reorder(price: :desc)
    when "name_asc"   then products.reorder(name: :asc)
    when "name_desc"  then products.reorder(name: :desc)
    when "oldest"     then products.reorder(created_at: :asc)
    else products.reorder(created_at: :desc)
    end
  end
end
