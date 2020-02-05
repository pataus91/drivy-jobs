require_relative 'option'

class Price
  def initialize(rental)
    @rental = rental
  end

  def final_price
    rental_duration = (@rental.end_date - @rental.start_date + 1).to_i
    price = basic_price(rental_duration)
    options = @rental.repository.find_option(@rental.id)
    options_type = find_option_type(options)
    option_fee = calculate_option_fee(options_type, rental_duration)
    commission = Commission.new(price, rental_duration)
    commissions = commission.calculate_commissions(option_fee)
    fees = commission.commission.to_i
    driver = driver(price, option_fee)
    owner = owner(price, fees, option_fee)
    { id: @rental.id, options: options_type, actions: [driver, owner, commissions[0], \
      commissions[1], commissions[2]] }
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

  def basic_price(rental_duration)
    price_per_day = @rental.repository.find_car(@rental.car_id).price_per_day
    price_per_km = @rental.repository.find_car(@rental.car_id).price_per_km
    price_duration = discount(rental_duration, price_per_day)
    price_duration + @rental.distance * price_per_km
  end

  def driver(price, option_fee)
    option_fee.each do |option|
      price += option[1]
    end

    { who: 'driver', type: 'debit', amount: price }
  end

  def owner(price, fees, option_fee)
    option_fee.each do |option|
      if option[0] == 'gps'
        price += option[1]
      elsif option[0] == 'baby_seat'
        price += option[1]
      end
    end

    { who: 'owner', type: 'credit', amount: (price - fees) }
  end

  def find_option_type(options)
    option_types = []
    options.each do |option|
      option_types << option.type
    end
    option_types
  end

  def find_option_fee(type)
    type = type

    case type
    when 'gps'
      500
    when 'baby_seat'
      200
    when 'additional_insurance'
      1000
    else
      0
    end
  end

  def calculate_option_fee(options, rental_duration)
    options_details = {}
    options.each do |option|
      fee = find_option_fee(option) * rental_duration
      options_details[option] = fee
    end
    options_details
  end
end

