require "rails_helper"

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      category = build(:category)
      expect(category).to be_valid
    end

    it "requires a name" do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("não pode ficar em branco")
    end

    it "requires a unique name" do
      create(:category, name: "Electronics")
      category = build(:category, name: "Electronics")
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("já está em uso")
    end

    it "requires a slug" do
      category = build(:category, slug: nil)
      expect(category).not_to be_valid
      expect(category.errors[:slug]).to include("não pode ficar em branco")
    end

    it "requires a unique slug" do
      create(:category, slug: "electronics")
      category = build(:category, slug: "electronics")
      expect(category).not_to be_valid
      expect(category.errors[:slug]).to include("já está em uso")
    end
  end

  describe "associations" do
    it "has many products" do
      category = create(:category)
      product = create(:product, category: category)
      expect(category.products).to include(product)
    end
  end

  describe "scopes" do
    it "returns ordered categories by name" do
      c2 = create(:category, name: "Beta", slug: "beta")
      c1 = create(:category, name: "Alpha", slug: "alpha")
      expect(Category.ordered).to eq([c1, c2])
    end

    it "excludes discarded categories by default" do
      create(:category, :discarded)
      expect(Category.kept.count).to eq(0)
    end
  end

  describe "discard" do
    it "soft deletes the record" do
      category = create(:category)
      category.discard!
      expect(category).to be_discarded
      expect(category.discarded_at).to be_present
    end

    it "can be restored" do
      category = create(:category, :discarded)
      category.undiscard!
      expect(category).not_to be_discarded
    end
  end

  describe "normalizations" do
    it "parameterizes the slug" do
      category = create(:category, name: "My Category", slug: "My Category")
      expect(category.slug).to eq("my-category")
    end
  end
end
