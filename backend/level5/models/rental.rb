require 'date'
require_relative 'commission'
require_relative 'option'
require_relative 'price'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance, :car_id, :repository

  def initialize(params, repository)
    @id = params['id']
    @car_id = params['car_id']
    @start_date = Date.parse(params['start_date'])
    @end_date = Date.parse(params['end_date'])
    @distance = params['distance']
    @repository = repository
  end

  def rental_price
    price = Price.new(self)
    price.final_price
  end
end
