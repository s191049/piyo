class Post < ApplicationRecord
  belongs_to :board
  validates :body, presence: true
  has_many_attached :attached_files
end
