class Counter < ApplicationRecord
  belongs_to :car
  validates :visit_count, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}

  def countup
    self.increment!(:visit_count)
  end

  def countdown
    self.decrement!(:visit_count)
  end
end
