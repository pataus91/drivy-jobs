require_relative '../models/rental'
require_relative '../models/car'
require 'json'

class Repository
  attr_reader :database

  def initialize(file_path)
    @file_path = file_path
    @database = load_json
  end

  def cars_all
    @database['cars'].map { |car| Car.new(car) }
  end

  def rentals_all
    @database['rentals'].map { |rental| Rental.new(rental, self) }
  end

  def find_car(id)
    cars_all.find { |car| car.id == id }
  end

  def find_rental(id)
    rentals_all.find { |rental| rental.id == id }
  end

  def calculate_rental_prices(hsh)
    save_json(hsh)
  end

  private

  def load_json
    file = File.read(@file_path)
    JSON.parse(file)
  end

  def save_json(hsh)
    File.open('data/output.json', 'w') do |file|
      file.write(JSON.pretty_generate(hsh))
    end
  end
end

