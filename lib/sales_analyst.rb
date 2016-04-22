require_relative "sales_engine"

class SalesAnalyst

  attr_reader :sales_engine

  def initialize(sales_engine_object)

    @sales_engine = sales_engine_object
    @total_items = @sales_engine.items.all.length #does not like length
    @total_merchants = @sales_engine.merchants.all.length #does not like length
    @mean_merchant_items = average_items_per_merchant
    @mean_item_price = average_item_price
    # @total_invoices = @sales_engine.invoice.all.length
  end

  def average_items_per_merchant
    numerator = @total_items.to_f
    denominator = @sales_engine.merchants.all.length
    (numerator/denominator).round(2)
  end

  def average_items_per_merchant_standard_deviation
    squares = @sales_engine.merchants.all.map do |merchant|
      (merchant.items.length - @mean_merchant_items) ** 2
    end
    Math.sqrt(squares.reduce(:+) / (@total_merchants - 1)).round(2)
  end

  def merchants_with_high_item_count
    cutoff = @mean_merchant_items + average_items_per_merchant_standard_deviation
    @sales_engine.merchants.all.find_all do |merchant|
      merchant.items.length > cutoff
    end
  end

  def average_item_price_for_merchant(merchant_id)
    total_items = @sales_engine.merchants.find_by_id(merchant_id).items.length
    total_price = @sales_engine.merchants.find_by_id(merchant_id).items.reduce(0) do |sum, item|
      sum += item.unit_price
    end
    (total_price / total_items).round(2)
  end

  def average_average_price_per_merchant
    averages = @sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (averages.reduce(:+) / @total_merchants).round(2)
  end

  def golden_items
    price_std = price_standard_deviation
    cutoff = @mean_item_price + ((price_std) * 2)
    @sales_engine.items.all.find_all do |item|
      item.unit_price > cutoff
    end
  end

  def average_item_price
    total = @sales_engine.items.all.map do |item|
      item.unit_price
    end
    total.reduce(:+)/ @total_items
  end

  def price_standard_deviation
    squares = @sales_engine.items.all.map do |item|
      (item.unit_price - @mean_item_price) ** 2
    end
    Math.sqrt(squares.reduce(:+) / (@total_items - 1)).round(2)
  end

  def average_invoices_per_merchant

    # numerator = @total_invoices.to_f
    # denominator = @sales_engine.invoice.all.length
    # (numerator/denominator).round(2)

    total_merchants = @sales_engine.merchants.find_by_id(merchant_id).invoices.length
    total_invoices = @sales_engine.invoices.find_by_id(id).invoice.reduce(0) do |sum, item|
      sum += item.invoices
    end
    (total_invoices / total_merchants).round(2)
  end

end
