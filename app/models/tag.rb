class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :microposts, through: :taggings
end
