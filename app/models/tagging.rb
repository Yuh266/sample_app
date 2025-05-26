class Tagging < ApplicationRecord
  belongs_to :micropost
  belongs_to :tag

  accepts_nested_attributes_for :tag
end
