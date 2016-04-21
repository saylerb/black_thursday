require_relative "sales_engine"

class SalesAnalyst

  attr_reader :sales_engine

  def initialize(sales_engine_object)

    @sales_engine = sales_engine_object
    @total_items = @sales_engine.items.all.length
    @total_merchants = @sales_engine.merchants.all.length
    @mean = average_items_per_merchant
  end

  def average_items_per_merchant
    numerator = @total_items.to_f
    denominator = @sales_engine.merchants.all.length
    (numerator/denominator).round(2)

    #need total # of items for a given merchant
    #divide by

    #to float => 2.88
  end


  def average_items_per_merchant_standard_deviation
    squares = @sales_engine.merchants.all.map do |merchant|
      (merchant.items.length - @mean) ** 2
    end
    Math.sqrt(squares.reduce(:+) / (@total_merchants - 1)).round(2)

  end


    #set = [3,4,5]
    #std_dev = sqrt( ( (3-4)^2+(4-4)^2+(5-4)^2 ) / 2 )
    # => 3.26

  def merchants_with_high_item_count

    cutoff = @mean + average_items_per_merchant_standard_deviation

    @sales_engine.merchants.all.find_all do |merchant|
      merchant.items.length > cutoff
    end

    # => [merchant, merchant, merchant]
  end

  def average_item_price_for_merchant(merchant_id)
    total_items = @sales_engine.merchants.find_by_id(merchant_id).items.length
    total_price = @sales_engine.merchants.find_by_id(merchant_id).items.reduce(0) do |sum, item|
      sum += item.unit_price
    end

    total_price / total_items


    # => BigDecimal
  end

  def average_average_price_per_merchant

    averages = @sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end

    (averages.reduce(:+) / @total_merchants).round(2)



    # => BigDecimal
  end

  def golden_items
    # => [<item>, <item>, <item>, <item>]
  end

end
