class Product < ApplicationRecord
  include Discard::Model

  belongs_to :category
  has_one_attached :image

  enum :status, {
    draft: 0,
    active: 1,
    inactive: 2,
    archived: 3
  }

  validates :name, presence: true
  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true,
                             numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validate :validate_image

  def validate_image
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/webp])
      errors.add(:image, "must be JPEG, PNG, or WebP")
    end

    if image.byte_size > 5.megabytes
      errors.add(:image, "must be less than 5MB")
    end
  end

  normalizes :name, with: ->(name) { name.strip }
  normalizes :sku, with: ->(sku) { sku.strip.upcase }

  scope :ordered, -> { order(created_at: :desc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_price_range, ->(min, max) {
    scope = all
    scope = scope.where("price >= ?", min) if min.present?
    scope = scope.where("price <= ?", max) if max.present?
    scope
  }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :search, ->(query) {
    return all if query.blank?
    where(
      "MATCH(name, description) AGAINST(? IN BOOLEAN MODE)",
      query
    )
  }
end
