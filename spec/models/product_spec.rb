require "rails_helper"

RSpec.describe Product, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      product = build(:product)
      expect(product).to be_valid
    end

    it "requires a name" do
      product = build(:product, name: nil)
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it "requires a non-negative price" do
      product = build(:product, price: -1)
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include("must be greater than or equal to 0")
    end

    it "requires stock quantity to be an integer >= 0" do
      product = build(:product, stock_quantity: -1)
      expect(product).not_to be_valid
      expect(product.errors[:stock_quantity]).to include("must be greater than or equal to 0")
    end

    it "requires a unique SKU" do
      create(:product, sku: "TEST-SKU")
      product = build(:product, sku: "TEST-SKU")
      expect(product).not_to be_valid
      expect(product.errors[:sku]).to include("has already been taken")
    end

    it "requires a status" do
      product = build(:product, status: nil)
      expect(product).not_to be_valid
      expect(product.errors[:status]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to a category" do
      product = create(:product)
      expect(product.category).to be_a(Category)
    end
  end

  describe "scopes" do
    let!(:active_product) { create(:product, status: :active) }
    let!(:draft_product) { create(:product, status: :draft) }
    let!(:inactive_product) { create(:product, status: :inactive) }

    it "excludes discarded products by default" do
      create(:product, :discarded)
      expect(Product.kept.count).to eq(3)
    end

    it "filters by status" do
      expect(Product.by_status("active")).to contain_exactly(active_product)
    end

    it "filters by category" do
      product = create(:product)
      expect(Product.by_category(product.category_id)).to include(product)
    end

    it "filters by price range" do
      cheap = create(:product, price: 10)
      expensive = create(:product, price: 100)
      result = Product.by_price_range(5, 50)
      expect(result).to include(cheap)
      expect(result).not_to include(expensive)
    end

    it "orders by creation date descending" do
      oldest = create(:product, created_at: 2.days.ago)
      newest = create(:product, created_at: 1.day.ago)
      expect(Product.ordered.where(id: [newest.id, oldest.id])).to eq([newest, oldest])
    end
  end

  describe "search" do
    it "uses MATCH AGAINST with boolean mode" do
      sql = Product.search("test query").to_sql
      expect(sql).to match(/MATCH\(.*?\) AGAINST\('test query' IN BOOLEAN MODE\)/)
    end

    it "returns all products when query is blank" do
      create(:product, name: "Widget")
      expect(Product.search("").count).to eq(Product.count)
    end
  end

  describe "discard" do
    it "soft deletes and restores" do
      product = create(:product)
      product.discard!
      expect(product).to be_discarded
      product.undiscard!
      expect(product).not_to be_discarded
    end
  end

  describe "normalizations" do
    it "upcases the SKU" do
      product = create(:product, sku: "test-sku")
      expect(product.sku).to eq("TEST-SKU")
    end
  end

  describe "enums" do
    it "defines status values" do
      expect(Product.statuses).to eq({
        "draft" => 0,
        "active" => 1,
        "inactive" => 2,
        "archived" => 3
      })
    end
  end
end
