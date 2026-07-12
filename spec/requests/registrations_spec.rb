require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET /registration/new" do
    it "renders the sign-up form" do
      get new_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /registration" do
    it "creates a new user and signs in" do
      expect {
        post registration_path, params: { user: { email_address: "new@example.com", password: "password123", password_confirmation: "password123" } }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(root_path)
    end

    it "re-renders with invalid params" do
      post registration_path, params: { user: { email_address: "", password: "short" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "re-renders when passwords do not match" do
      post registration_path, params: { user: { email_address: "new@example.com", password: "password123", password_confirmation: "different" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
