require "bigdecimal"

class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id,
              :item_repository

  def initialize(hash, item_respository)
    @id = hash[:id].to_i
    @name = hash[:name]
    @description = hash[:description]
    @unit_price = BigDecimal.new(hash[:unit_price])/100
    @created_at = Time.parse(hash[:created_at])
    @updated_at = Time.parse(hash[:updated_at])
    @merchant_id = hash[:merchant_id].to_i
    @item_repository = item_repository
  end

  def unit_price_to_dollars
    (@unit_price/100).to_f
  end

end
