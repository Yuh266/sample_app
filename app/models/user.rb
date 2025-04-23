class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token 

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password

  validates :password, presence: true, length: { minimum: 6 } , allow_nil: true

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def activate
    # update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end
   # Gửi email kích hoạt
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  # Băm token (dùng để lưu vào DB)
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token 
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email 
    # self.email = email.downcase 
    email.downcase! # Thay đổi trực tiếp biến email

  end


end
