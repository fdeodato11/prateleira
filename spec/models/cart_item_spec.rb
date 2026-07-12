require "rails_helper"

RSpec.describe CartItem, type: :model do
  describe "validations" do
    it "validates quantity greater than 0" do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).not_to be_valid
      expect(cart_item.errors[:quantity]).to include("must be greater than 0")
    end
  end
end
