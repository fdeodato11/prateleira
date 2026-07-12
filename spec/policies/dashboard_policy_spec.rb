require "rails_helper"

RSpec.describe DashboardPolicy do
  subject(:policy) { described_class }

  context "when user is an administrator" do
    let(:user) { build_stubbed(:user, :admin) }

    it "permits show" do
      expect(policy.new(user, :dashboard).show?).to be true
    end
  end

  context "when user is not an administrator" do
    let(:user) { build_stubbed(:user) }

    it "denies show" do
      expect(policy.new(user, :dashboard).show?).to be false
    end
  end
end
