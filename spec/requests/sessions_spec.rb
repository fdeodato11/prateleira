require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /session" do
    it "signs in with valid credentials" do
      post session_url, params: { email_address: user.email_address, password: "password123" }
      expect(response).to redirect_to(root_path)
    end

    it "rejects invalid credentials" do
      post session_url, params: { email_address: user.email_address, password: "wrong" }
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "DELETE /session" do
    it "signs out" do
      sign_in(user)
      delete session_url
      expect(response).to redirect_to(new_session_path)
    end
  end
end
