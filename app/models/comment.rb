class Comment < ApplicationRecord
  belongs_to :user
  has_many :children, class_name: 'Comment', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Comment', optional: true

  scope :roots, -> { where(parent_id: nil) }

  validates :content, presence: { allow_blank: false }
end
