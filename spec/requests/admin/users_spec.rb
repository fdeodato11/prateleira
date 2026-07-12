require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }

  describe "GET /admin/users" do
    it "requires authentication" do
      get admin_users_path
      expect(response).to redirect_to(new_session_path)
    end

    it "renders the index for admins" do
      sign_in(admin)
      get admin_users_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects non-admin users" do
      sign_in(create(:user))
      get admin_users_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /admin/users/:id" do
    before { sign_in(admin) }

    it "shows the user" do
      user = create(:user)
      get admin_user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /admin/users/:id" do
    before { sign_in(admin) }

    it "toggles admin role" do
      user = create(:user, admin: false)
      patch admin_user_path(user), params: { user: { admin: true } }
      expect(user.reload).to be_admin
      expect(response).to redirect_to(admin_users_path)
    end

    it "prevents self-demotion" do
      admin.reload
      patch admin_user_path(admin), params: { user: { admin: false } }
      expect(admin.reload).to be_admin
    end
  end
end
