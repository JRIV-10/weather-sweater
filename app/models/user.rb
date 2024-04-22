class User < ApplicationRecord
  before_create :new_key

  validates :email, presence: true, uniqueness: true
  validates :api, uniqueness: true
  validates :password, presence: true
  has_secure_password

  private

  def new_key
    self.api_key = SecureRandom::base58(16)
  end
end
