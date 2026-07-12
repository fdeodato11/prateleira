require "rails_helper"

RSpec.describe CategoryPolicy do
  subject(:policy) { described_class }

  let(:category) { build_stubbed(:category) }

  context "when user is an administrator" do
    let(:user) { build_stubbed(:user, :admin) }

    it { expect(policy.new(user, category).index?).to be true }
    it { expect(policy.new(user, category).show?).to be true }
    it { expect(policy.new(user, category).create?).to be true }
    it { expect(policy.new(user, category).new?).to be true }
    it { expect(policy.new(user, category).update?).to be true }
    it { expect(policy.new(user, category).edit?).to be true }
    it { expect(policy.new(user, category).destroy?).to be true }
    it { expect(policy.new(user, category).restore?).to be true }
  end

  context "when user is not an administrator" do
    let(:user) { build_stubbed(:user) }

    it { expect(policy.new(user, category).index?).to be false }
    it { expect(policy.new(user, category).show?).to be false }
    it { expect(policy.new(user, category).create?).to be false }
    it { expect(policy.new(user, category).update?).to be false }
    it { expect(policy.new(user, category).destroy?).to be false }
  end
end
