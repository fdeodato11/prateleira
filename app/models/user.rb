class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true,
            format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address" }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt.last(10)
  end

  def administrator?
    admin?
  end
end
