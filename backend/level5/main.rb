# require_relative 'repositories/repository'
# require_relative 'models/price'

# def calculate_price(repository, price)
#   hsh = { rentals: [] }
#   repository.rentals_all.each do |rental|
#     hsh[:rentals] << rental.rental_price
#   end
#   repository.calculate_rental_prices(hsh)
# end

# repository = Repository.new('data/input.json')
# price = Price.new
# calculate_price(repository, price)
# p repository.options_all.type

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
