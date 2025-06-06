class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy  
  has_many :passive_relationships, class_name: "Relationship",    
                                   foreign_key: "followed_id",   
                                   dependent: :destroy                          
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  attr_accessor :remember_token, :activation_token , :reset_token

  before_save :downcase_email
  before_create :create_activation_digest
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 } , allow_nil: true
  has_secure_password
  
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  def send_activation_email
    # UserMailer.account_activation(self).deliver_now 
    MailerJob.perform_later('UserMailer', 'account_activation', self, self.activation_token) 
  end
  # Sends password reset email. 
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  # Lưu remember_token và remember_digest vào cookie & DB
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end
  def forget
    update_attribute(:remember_digest, nil)
  end
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  def follow(other_user)
    following << other_user unless following.include?(other_user)
  end
  def unfollow(other_user)
    following.delete(other_user)
  end
  def following?(other_user)
    following.include?(other_user)
  end
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"

    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
             .includes(:user, image_attachment: :blob)
  end

  def session_token
    remember_digest || remember
  end   
  
  class << self
    def new_token
      SecureRandom.urlsafe_base64 
    end
    # Băm token (dùng để lưu vào DB) 
    def digest(string) 
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

  private

  def create_activation_digest
    self.activation_token  = User.new_token 
    self.activation_digest = User.digest(activation_token)
  end
  def downcase_email 
    self.email.downcase
  end
end




