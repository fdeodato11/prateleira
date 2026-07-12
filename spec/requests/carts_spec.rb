require "rails_helper"

RSpec.describe "Carts", type: :request do
  let(:product) { create(:product, :active) }

  def add_item_to_session_cart(product_id, quantity: 1)
    post add_item_cart_path(product_id: product_id, quantity: quantity)
  end

  describe "GET /cart" do
    it "shows the cart" do
      get cart_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /cart/add_item" do
    it "adds a product to the cart" do
      expect {
        add_item_to_session_cart(product.id)
      }.to change(CartItem, :count).by(1)
      expect(response).to redirect_to(cart_path)
    end

    it "increments quantity for existing items" do
      add_item_to_session_cart(product.id)

      expect {
        add_item_to_session_cart(product.id)
      }.not_to change(CartItem, :count)
      expect(CartItem.find_by(product: product).quantity).to eq(2)
    end

    it "redirects with alert if product is not found" do
      post add_item_cart_path(product_id: 0)
      expect(response).to redirect_to(products_path)
    end
  end

  describe "DELETE /cart/remove_item" do
    it "removes the product from cart" do
      add_item_to_session_cart(product.id)

      expect {
        delete remove_item_cart_path(product_id: product.id)
      }.to change(CartItem, :count).by(-1)
      expect(response).to redirect_to(cart_path)
    end
  end
end
