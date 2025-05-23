class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [50, 50]
  end

  validates :content, presence: true, length: { maximum: 300 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }
end
