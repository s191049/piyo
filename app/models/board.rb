class Board < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true
  
end
