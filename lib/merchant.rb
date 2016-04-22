
class Merchant

  attr_reader :id, :name

  def initialize(row, merchant_repository)
    @id = row[:id].to_i
    @name = row[:name]
    @merchant_repository = merchant_repository
  end

  def items
    @merchant_repository.find_by_id(@id)
  end

  def invoices
    @merchant_repository.find_invoices_by_merchant_id(@id)
  end

end
