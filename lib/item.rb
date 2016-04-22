require "bigdecimal"
require "time"
require "pry"

class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id

  def initialize(row, item_repository)
    @id = row[:id].to_i
    @name = row[:name]
    @description = row[:description]
    @unit_price = BigDecimal.new(row[:unit_price])/100
    @created_at = Time.parse(row[:created_at])
    @updated_at = Time.parse(row[:updated_at])
    @merchant_id = row[:merchant_id].to_i
    @item_repository = item_repository
  end

  def unit_price_to_dollars
    (@unit_price/100).to_f
  end

  def merchant
    # binding.pry
    # @item_repository.sales_engine.merchants.find_by_id(@merchant_id)
    @item_repository.find_merchant_by_merchant_id(@merchant_id)
  end

end
