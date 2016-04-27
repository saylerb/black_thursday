require_relative "sales_engine"

class SalesAnalyst

  attr_reader :sales_engine, :total_invoices

  # TODO: refactor "@sales_engine" methods so there's only one dot after them
  def initialize(sales_engine_object)
    @sales_engine = sales_engine_object
    @total_items = @sales_engine.items.all.length
    @total_merchants = @sales_engine.merchants.all.length
    @total_invoices = @sales_engine.invoices.all.length
    @mean_merchant_items = average_items_per_merchant
    @mean_merchant_invoices = average_invoices_per_merchant
    @mean_item_price = average_item_price
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
    total_invoices = @sales_engine.invoices.all.length
    (total_invoices.to_f / @total_merchants).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    squares = @sales_engine.merchants.all.map do |merchant|
      (merchant.invoices.length - @mean_merchant_invoices) ** 2
    end
    Math.sqrt(squares.reduce(:+) / (@total_merchants - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    invoice_std = invoice_standard_deviation
    cutoff = @mean_merchant_invoices + ((invoice_std) * 2)
    @sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.length > cutoff
    end
  end

  def invoice_standard_deviation
    squares = @sales_engine.merchants.all.map do |merchant|
      (merchant.invoices.length - @mean_merchant_invoices) ** 2
    end
    Math.sqrt(squares.reduce(:+) / (@total_merchants - 1)).round(2)
  end

  def bottom_merchants_by_invoice_count
    invoice_std = invoice_standard_deviation
    cutoff = @mean_merchant_invoices - ((invoice_std) * 2)
    @sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.length < cutoff
    end
  end

  def invoices_to_days
    @sales_engine.invoices.all.map do |invoice|
      invoice.created_at.strftime("%A")
    end
  end

  def count_invoices_by_day
    days = ["Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday"]
    days.map do |day|
      invoices_to_days.count(day)
    end
  end

  def average_invoices_per_day
    @sales_engine.invoices.all.length / 7
  end

  def invoices_per_day_standard_deviation
    squares = count_invoices_by_day.map do |number|
      (number - average_invoices_per_day) ** 2
    end
    Math.sqrt(squares.reduce(:+) / 6).round(2)
  end

  def top_days_grouped_by_count
    days = ["Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday"]
    zipped = days.zip(count_invoices_by_day)
    zipped.reduce({}) do |result, sub_array|
      result[sub_array[0]] = sub_array[1]; result
    end
  end

  def top_days_by_invoice_count
    days = ["Monday", "Tuesday", "Wednesday", "Thursday",
              "Friday", "Saturday", "Sunday"]

    invoice_std = invoices_per_day_standard_deviation
    cutoff = average_invoices_per_day + invoice_std
    days.find_all do |day|
      top_days_grouped_by_count[day] > cutoff
    end
  end

  def find_statuses
    @sales_engine.invoices.all.map { |invoice| invoice.status }.uniq
  end

  def group_invoices_by_status
    statuses = [:pending, :shipped, :returned]
    counts = statuses.map do |status|
      @sales_engine.invoices.find_all_by_status(status).length
    end

    percentages = counts.map do |count|
      (count.to_f / @total_invoices) * 100
    end

    statuses.zip(percentages).to_h
  end

  def invoice_status(status)
    group_invoices_by_status[status].round(2)
  end

  def total_revenue_by_date(date)
    invoices_for_date = @sales_engine.invoices.all.find_all do |invoice|
      invoice.created_at.to_date == date.to_date
    end

    invoices_for_date.reduce(BigDecimal.new(0)) do |total, invoice|
      total += invoice.total; total
    end
  end

  def top_revenue_earners(number = 20)
    invoices = @sales_engine.merchants.all.map do |merchant|
      merchant.invoices
    end

    totals = invoices.map do |invoices|
      invoices.map { |invoice| invoice.total }.reduce(:+)
    end

    sorted = @sales_engine.merchants.all.zip(totals).sort_by do |pair|
      -pair[1]
    end

    sorted[0...number].map { |pair| pair[0] }
  end

  def merchants_ranked_by_revenue
    top_revenue_earners(@total_merchants)
  end

  def merchants_with_pending_invoices
    unpaid_invoices = @sales_engine.invoices.all.find_all do |invoice|
      !invoice.is_paid_in_full?
    end

    merchants_with_unpaid_invoices = unpaid_invoices.map do |invoice|
      invoice.merchant
    end

    merchants_with_unpaid_invoices.uniq
  end

  def merchants_with_only_one_item
    @sales_engine.merchants.all.find_all do |merchant|
      merchant.items.length == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    month_number = Date::MONTHNAMES.index(month.capitalize)

    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.month == month_number
    end
  end

  def revenue_by_merchant(merchant_id)
    invoices = @sales_engine.merchants.find_invoices_by_merchant_id(merchant_id)

    invoices.reduce(0) do |sum, invoice|
      sum += invoice.total; sum
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    invoices = @sales_engine.merchants.find_invoices_by_merchant_id(merchant_id)

    paid_invoices = invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end

    paid_invoice_items = paid_invoices.map do |invoice|
      @sales_engine.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten

    item_quantities = paid_invoice_items.each_with_object(Hash.new(0)) do |invoice_item, counts|
      counts[invoice_item.item_id] += invoice_item.quantity
    end

    max_quantity = item_quantities.max_by { |key, value| value }[1]

    max_items = item_quantities.find_all do |item_id, quantity|
      quantity == max_quantity
    end

    items_ids = max_items.map { |item_id, quantity| item_id }

    result = items_ids.map do |item_id|
      @sales_engine.items.find_by_id(item_id)
    end

    result 

  end

  def best_item_for_merchant(merchant_id)
    invoices = @sales_engine.merchants.find_invoices_by_merchant_id(merchant_id)

    paid_invoices = invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end

    paid_invoice_items = paid_invoices.map do |invoice|
      @sales_engine.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
    
    item_revenues = paid_invoice_items.each_with_object(Hash.new(0)) do |invoice_item, counts|
      counts[invoice_item.item_id] += invoice_item.unit_price * invoice_item.quantity
    end

    max_revenue = item_revenues.max_by { |key, value| value }[1]

    max_item = item_revenues.find do |item_id, revenue|
      revenue == max_revenue
    end

    @sales_engine.items.find_by_id(max_item[0])

  end


end
