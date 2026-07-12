class CartsController < ApplicationController
  allow_unauthenticated_access only: %i[show add_item remove_item]

  before_action :set_cart, only: %i[show add_item remove_item]

  def show
  end

  def add_item
    product = Product.kept.active.find(params[:product_id])
    @cart.add_product(product, quantity: (params[:quantity] || 1).to_i)
    redirect_to cart_path, notice: t(".notice")
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: t(".alert")
  end

  def remove_item
    product = Product.find(params[:product_id])
    @cart.remove_product(product)
    redirect_to cart_path, notice: t(".notice")
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by!(id: session[:cart_id])
    session[:cart_id] = @cart.id
  end
end
