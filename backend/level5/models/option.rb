class Option
  attr_reader :id, :rental_id, :type

  def initialize(params)
    @id = params['id']
    @rental_id = params['rental_id']
    @type = params['type']
  end
end
