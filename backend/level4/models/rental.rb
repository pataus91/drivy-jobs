require 'date'
require_relative 'commission'

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
    price_duration = discount(rental_duration, price_per_day)
    price = price_duration + @distance * price_per_km
    commission = Commission.new(price, rental_duration)
    commissions = commission.calculate_commissions
    fees = commission.commission.to_i
    driver = driver(price)
    owner = owner(price, fees)
    { id: @id, actions: [driver, owner, commissions[0], commissions[1], commissions[2]] }
  end

  def discount(days, price_per_day)
    count = 1
    price = []

    while count <= days
      if count == 1
        price << price_per_day
      elsif count > 1 && count < 5
        price << price_per_day * 0.9
      elsif count >= 5 && count < 11
        price << price_per_day * 0.7
      elsif count > 10
        price << price_per_day * 0.5
      else
        0
      end

      count += 1
    end

    price.inject(0, :+).to_i
  end

  def driver(price)
    { who: 'driver', type: 'debit', amount: price }
  end

  def owner(price, fees)
    { who: 'owner', type: 'credit', amount: (price - fees) }
  end
end
