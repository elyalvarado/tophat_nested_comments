class Comment < ApplicationRecord
  belongs_to :user

  validates :content, presence: { allow_blank: false }
end
