require "rails_helper"

RSpec.describe ProductPolicy do
  subject(:policy) { described_class }

  let(:product) { build_stubbed(:product) }

  context "when user is an administrator" do
    let(:user) { build_stubbed(:user, :admin) }

    it "permits index" do
      expect(policy.new(user, product).index?).to be true
    end

    it "permits show" do
      expect(policy.new(user, product).show?).to be true
    end

    it "permits create" do
      expect(policy.new(user, product).create?).to be true
    end

    it "permits new" do
      expect(policy.new(user, product).new?).to be true
    end

    it "permits update" do
      expect(policy.new(user, product).update?).to be true
    end

    it "permits edit" do
      expect(policy.new(user, product).edit?).to be true
    end

    it "permits destroy" do
      expect(policy.new(user, product).destroy?).to be true
    end

    it "permits restore" do
      expect(policy.new(user, product).restore?).to be true
    end
  end

  context "when user is not an administrator" do
    let(:user) { build_stubbed(:user) }

    it "denies index" do
      expect(policy.new(user, product).index?).to be false
    end

    it "denies show" do
      expect(policy.new(user, product).show?).to be false
    end

    it "denies create" do
      expect(policy.new(user, product).create?).to be false
    end

    it "denies update" do
      expect(policy.new(user, product).update?).to be false
    end

    it "denies destroy" do
      expect(policy.new(user, product).destroy?).to be false
    end

    it "denies restore" do
      expect(policy.new(user, product).restore?).to be false
    end
  end
end
