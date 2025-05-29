class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :taggings, allow_destroy: true

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size: { less_than: 5.megabytes,
                            message: "should be less than 5MB" }
  before_validation :assign_existing_or_new_tags

  private

  def assign_existing_or_new_tags
    seen_tag_names = []
    taggings.each do |tagging|
      if tagging.tag && tagging.tag.name.present?
        existing_tag = Tag.find_by(name: tagging.tag.name.strip.downcase)
        if existing_tag
          tagging.tag = existing_tag
        else
          tagging.tag.name = tagging.tag.name.strip.downcase
        end
      else
        tagging.mark_for_destruction
      end

      tag_name = tagging.tag.name 
      if seen_tag_names.include?(tag_name)
        tagging.mark_for_destruction
      else
        seen_tag_names << tag_name
      end
    end
    
  end

end


