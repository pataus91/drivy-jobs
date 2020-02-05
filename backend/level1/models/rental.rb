require 'date'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(params, repository)
    @id = params['id']
    @car_id = params['car_id']
    @start_date = Date.parse(params['start_date'])
    @end_date = Date.parse(params['end_date'])
    @distance = params['distance']
    @repository = repository
  end

  def rental_price
    rental_duration = (@end_date - @start_date + 1).to_i
    price_per_day = @repository.find_car(@car_id).price_per_day
    price_per_km = @repository.find_car(@car_id).price_per_km
    price = rental_duration * price_per_day + @distance * price_per_km
    { id: @id, price: price }
  end
end
