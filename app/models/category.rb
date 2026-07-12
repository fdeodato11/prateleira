class Category < ApplicationRecord
  include Discard::Model

  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  normalizes :name, with: ->(name) { name.strip }
  normalizes :slug, with: ->(slug) { slug.strip.parameterize }

  scope :ordered, -> { order(name: :asc) }
end
