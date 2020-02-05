class Commission
  def initialize(price, days)
    @commission = price * 0.3
    @days = days
  end

  def calculate_commissions
    insurance_commission = @commission / 2
    assistance_commission = @days * 100
    getaround_commission = @commission - insurance_commission - assistance_commission
    { insurance_fee: insurance_commission.to_i,
      assistance_fee: assistance_commission.to_i,
      getaround_fee: getaround_commission.to_i }
  end
end
