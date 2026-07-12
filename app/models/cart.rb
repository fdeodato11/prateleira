class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total
    cart_items.includes(:product).sum { |item| item.product.price * item.quantity }
  end

  def add_product(product, quantity: 1)
    item = cart_items.find_or_initialize_by(product: product)
    item.quantity = (item.quantity || 0) + quantity
    item.save!
  end

  def remove_product(product)
    cart_items.where(product: product).destroy_all
  end
end
