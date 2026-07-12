require "rails_helper"

RSpec.describe DashboardPolicy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }

  it "permits show for administrators" do
    expect(policy.new(user, :dashboard).show?).to be true
  end
end
