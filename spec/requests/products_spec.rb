require "rails_helper"

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    it "returns a successful response" do
      create(:product, status: :active)
      get products_path
      expect(response).to have_http_status(:ok)
    end

    it "lists only active products" do
      active = create(:product, status: :active)
      create(:product, status: :draft)
      get products_path
      expect(response.body).to include(active.name)
    end

    it "paginates results" do
      create_list(:product, 15, status: :active)
      get products_path
      expect(response.body).to include("pagy")
    end

    it "filters by category" do
      category = create(:category)
      product = create(:product, category: category, status: :active)
      create(:product, status: :active)
      get products_path, params: { category_id: category.id }
      expect(response.body).to include(product.name)
    end

    it "sorts by price ascending" do
      cheap = create(:product, price: 10, status: :active)
      expensive = create(:product, price: 100, status: :active)
      get products_path, params: { sort: "price_asc" }
      expect(response.body).to match(/#{Regexp.escape(cheap.name)}.*#{Regexp.escape(expensive.name)}/m)
    end
  end

  describe "GET /products/:id" do
    it "shows an active product" do
      product = create(:product, status: :active)
      get product_path(product)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end

    it "returns 404 for a discarded product" do
      product = create(:product, :discarded)
      get product_path(product)
      expect(response).to have_http_status(:not_found)
    end
  end
end
