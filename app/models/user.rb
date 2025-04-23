class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password

  validates :password, presence: true, length: { minimum: 6 } , allow_nil: true
  
  # def remember
  #   self.remember_token = User.new_token
  #   update_attribute(:remember_digest, User.digest(remember_token))
  #   remember_digest
  # end
  # # Returns a session token to prevent session hijacking.
  # # We reuse the remember digest for convenience.
  # def session_token
  #   remember_digest || remember
  # end


end
