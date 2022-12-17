class Post < ApplicationRecord
  belongs_to :board
  validates :body, presence: true
end
