require "rails_helper"

RSpec.describe "Admin::Products", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }

  describe "GET /admin/products" do
    before { sign_in(admin) }

    it "returns a successful response" do
      create(:product)
      get admin_products_path
      expect(response).to have_http_status(:ok)
    end

    it "includes discarded products" do
      product = create(:product, :discarded)
      get admin_products_path
      expect(response.body).to include(product.name)
    end
  end

  describe "GET /admin/products/new" do
    before { sign_in(admin) }

    it "renders the new product form" do
      get new_admin_product_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/products" do
    before { sign_in(admin) }

    it "creates a product with valid params" do
      product_params = attributes_for(:product, category_id: category.id)
      expect {
        post admin_products_path, params: { product: product_params }
      }.to change(Product, :count).by(1)
      expect(response).to redirect_to(admin_products_path)
    end

    it "re-renders form with invalid params" do
      expect {
        post admin_products_path, params: { product: { name: "" } }
      }.not_to change(Product, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /admin/products/:id/edit" do
    before { sign_in(admin) }

    it "renders the edit form" do
      product = create(:product)
      get edit_admin_product_path(product)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /admin/products/:id" do
    before { sign_in(admin) }

    it "updates the product" do
      product = create(:product)
      patch admin_product_path(product), params: { product: { name: "Updated Name" } }
      expect(product.reload.name).to eq("Updated Name")
      expect(response).to redirect_to(admin_products_path)
    end

    it "re-renders form with invalid params" do
      product = create(:product)
      patch admin_product_path(product), params: { product: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /admin/products/:id" do
    before { sign_in(admin) }

    it "discards the product" do
      product = create(:product)
      delete admin_product_path(product)
      expect(product.reload).to be_discarded
      expect(response).to redirect_to(admin_products_path)
    end
  end

  describe "POST /admin/products/:id/restore" do
    before { sign_in(admin) }

    it "restores the product" do
      product = create(:product, :discarded)
      post restore_admin_product_path(product)
      expect(product.reload).not_to be_discarded
      expect(response).to redirect_to(admin_products_path)
    end
  end

  describe "authentication" do
    it "redirects unauthenticated users to sign in" do
      get admin_products_path
      expect(response).to redirect_to(new_session_path)
    end

    it "redirects non-admin users to root" do
      sign_in(create(:user))
      get admin_products_path
      expect(response).to redirect_to(root_path)
    end
  end
end
