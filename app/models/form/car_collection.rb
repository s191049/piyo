class Form::CarCollection < Form::Base
  FORM_COUNT = 36
  attr_accessor :cars

  def initialize(attributes = {})
    super attributes
    self.cars = FORM_COUNT.times.map{ Car.new() } unless self.cars.present?
  end

  def cars_attributes=(attributes)
    self.cars = attributes.map { |_, v| Car.new(v) }
  end

  def save
    Car.transaction do
      self.cars.map do |car|
        if car.number.present?
          car.division = self.cars.first.division
          car.save
        end
      end
    end
      return true
    rescue => e
      return false
  end

  def valid_count
    cnt = 0
    self.cars.each do |c|
      cnt += 1 if c.valid?
    end
    return cnt
  end
end