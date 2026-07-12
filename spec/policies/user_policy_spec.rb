require "rails_helper"

RSpec.describe UserPolicy do
  subject(:policy) { described_class }

  let(:target_user) { build_stubbed(:user) }

  context "when user is an administrator" do
    let(:user) { build_stubbed(:user, :admin) }

    it { expect(policy.new(user, User).index?).to be true }
    it { expect(policy.new(user, target_user).show?).to be true }
    it { expect(policy.new(user, target_user).edit?).to be true }
    it { expect(policy.new(user, target_user).update?).to be true }
    it { expect(policy.new(user, user).update?).to be false }
  end

  context "when user is not an administrator" do
    let(:user) { build_stubbed(:user) }

    it { expect(policy.new(user, target_user).index?).to be false }
    it { expect(policy.new(user, target_user).show?).to be false }
    it { expect(policy.new(user, target_user).edit?).to be false }
    it { expect(policy.new(user, target_user).update?).to be false }
  end
end
