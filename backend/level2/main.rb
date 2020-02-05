require_relative 'repositories/repository'

def calculate_price(repository)
  hsh = { rentals: [] }
  repository.rentals_all.each do |rental|
    hsh[:rentals] << rental.rental_price
  end
  repository.calculate_rental_prices(hsh)
end

repository = Repository.new('data/input.json')
calculate_price(repository)
