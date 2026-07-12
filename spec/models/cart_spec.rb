require "rails_helper"

RSpec.describe Cart, type: :model do
  describe "#add_product" do
    it "adds a new product" do
      cart = Cart.create!
      product = create(:product)
      cart.add_product(product)
      expect(cart.cart_items.count).to eq(1)
    end

    it "increments quantity for existing product" do
      cart = Cart.create!
      product = create(:product)
      cart.add_product(product)
      cart.add_product(product)
      expect(cart.cart_items.find_by(product: product).quantity).to eq(2)
    end
  end

  describe "#remove_product" do
    it "removes the product line item" do
      cart = Cart.create!
      product = create(:product)
      cart.add_product(product)
      expect {
        cart.remove_product(product)
      }.to change(cart.cart_items, :count).by(-1)
    end
  end

  describe "#total" do
    it "sums up line totals" do
      cart = Cart.create!
      products = create_list(:product, 2, price: 10.00)
      products.each { |p| cart.add_product(p) }
      expect(cart.total).to eq(BigDecimal("20.00"))
    end
  end
end
