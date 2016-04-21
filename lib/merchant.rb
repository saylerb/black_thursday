
class Merchant

  attr_reader :id, :name

  def initialize(hash, merchant_repository)
    @id = hash[:id].to_i
    @name = hash[:name]
    @merchant_repository = merchant_repository
  end

  def items
    @merchant_repository.sales_engine.items.find_all_by_merchant_id(@id)
  end

end
