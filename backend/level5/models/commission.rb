class Commission
  attr_reader :commission
  def initialize(price, days)
    @commission = price * 0.3
    @days = days
  end

  def calculate_commissions(option_fee)
    insurance_commission = @commission / 2
    assistance_commission = @days * 100
    getaround_commission = @commission - insurance_commission - assistance_commission

    option_fee.each do |option|
      if option[0] == 'additional_insurance'
        getaround_commission += option[1];
      end
    end

    result = [
      {
        who: 'insurance',
        type: 'credit',
        amount: insurance_commission.to_i
      },
      {
        who: 'assistance',
        type: 'credit',
        amount: assistance_commission.to_i
      },
      {
        who: 'getaround',
        type: 'credit',
        amount: getaround_commission.to_i
      }]
  end
end
