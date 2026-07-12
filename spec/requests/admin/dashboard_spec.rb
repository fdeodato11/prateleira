require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }

  describe "GET /admin/dashboard" do
    it "requires authentication" do
      get admin_dashboard_path
      expect(response).to redirect_to(new_session_path)
    end

    it "renders the dashboard for authenticated admin" do
      sign_in(admin)
      get admin_dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects non-admin users" do
      sign_in(create(:user))
      get admin_dashboard_path
      expect(response).to redirect_to(root_path)
    end
  end
end
