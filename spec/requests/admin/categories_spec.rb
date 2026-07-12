require "rails_helper"

RSpec.describe "Admin::Categories", type: :request do
  let(:admin) { create(:user, :admin) }

  describe "GET /admin/categories" do
    it "requires authentication" do
      get admin_categories_path
      expect(response).to redirect_to(new_session_path)
    end

    it "renders the index for admins" do
      sign_in(admin)
      create(:category)
      get admin_categories_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects non-admin users" do
      sign_in(create(:user))
      get admin_categories_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /admin/categories" do
    before { sign_in(admin) }

    it "creates a category" do
      expect {
        post admin_categories_path, params: { category: { name: "New Cat", slug: "new-cat" } }
      }.to change(Category, :count).by(1)
      expect(response).to redirect_to(admin_categories_path)
    end

    it "re-renders with invalid params" do
      post admin_categories_path, params: { category: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /admin/categories/:id" do
    before { sign_in(admin) }

    it "updates the category" do
      category = create(:category)
      patch admin_category_path(category), params: { category: { name: "Updated" } }
      expect(category.reload.name).to eq("Updated")
      expect(response).to redirect_to(admin_categories_path)
    end
  end

  describe "DELETE /admin/categories/:id" do
    before { sign_in(admin) }

    it "discards the category" do
      category = create(:category)
      delete admin_category_path(category)
      expect(category.reload).to be_discarded
      expect(response).to redirect_to(admin_categories_path)
    end
  end

  describe "POST /admin/categories/:id/restore" do
    before { sign_in(admin) }

    it "restores the category" do
      category = create(:category, :discarded)
      post restore_admin_category_path(category)
      expect(category.reload).not_to be_discarded
      expect(response).to redirect_to(admin_categories_path)
    end
  end
end
