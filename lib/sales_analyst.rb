require_relative "sales_engine"
require_relative "sales_calculator"
require_relative "sales_analyst_days"

class SalesAnalyst

  include SalesCalculator
  include SalesAnalystDays

  attr_reader :se, :total_invoices, :total_merchants, :total_items

  def initialize(sales_engine_object)
    @se = sales_engine_object

    @total_items = @se.repo_size(:@items)
    @total_merchants = @se.repo_size(:@merchants)
    @total_invoices = @se.repo_size(:@invoices)

    @all_items = @se.all(:@items)
    @all_merchants = @se.all(:@merchants)
    @all_invoices = @se.all(:@invoices)

    @mean_merchant_items = average_items_per_merchant
    @mean_merchant_invoices = average_invoices_per_merchant
    @mean_item_price = average_item_price
  end

  def merchants_with_high_item_count
    cutoff = @mean_merchant_items + \
      average_items_per_merchant_standard_deviation
    @all_merchants.find_all { |merchant| merchant.total_items > cutoff }
  end

  def golden_items
    cutoff = @mean_item_price + price_standard_deviation * 2
    @all_items.find_all { |item| item.unit_price > cutoff }
  end

  def top_merchants_by_invoice_count
    cutoff = @mean_merchant_invoices + invoice_standard_deviation * 2
    @all_merchants.find_all { |merchant| merchant.total_invoices > cutoff }
  end

  def bottom_merchants_by_invoice_count
    cutoff = @mean_merchant_invoices - invoice_standard_deviation * 2
    @all_merchants.find_all { |merchant| merchant.total_invoices < cutoff }
  end

  def revenue_by_merchant(merchant_id)
    invoices = @se.find_invoices_by_merchant_id(merchant_id)
    invoices.reduce(0) { |sum, invoice| sum += invoice.total; sum }
  end


  def top_revenue_earners(number = 20)

    invoices_by_merchant = @all_merchants.map { |merchant| merchant.invoices }
    totals = invoices_by_merchant.map do |invoices|
      invoices.reduce(0) { |sum, invoice| sum += invoice.total; sum }
    end
    reverse_sorted = @all_merchants.zip(totals).sort_by { |pair| -pair[1] }
    reverse_sorted[0...number].map { |pair| pair[0] }
  end

  def merchants_ranked_by_revenue
    top_revenue_earners(@total_merchants)
  end

  def merchants_with_pending_invoices
    unpaid = @all_invoices.find_all { |invoice| !invoice.is_paid_in_full? }
    merchants_with_unpaid_invoices = unpaid.map { |invoice| invoice.merchant }
    merchants_with_unpaid_invoices.uniq
  end

  def merchants_with_only_one_item
    @all_merchants.find_all { |merchant| merchant.items.length == 1 }
  end

  def merchants_with_only_one_item_registered_in_month(month)
    month_number = Date::MONTHNAMES.index(month.capitalize)

    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.month == month_number
    end
  end

  def revenue_by_merchant(merchant_id)
    invoices = @se.find_invoices_by_merchant_id(merchant_id)

    invoices.reduce(0) { |sum, invoice| sum += invoice.total; sum }
  end

  def most_sold_item_for_merchant(merchant_id)
    invoices = @se.find_invoices_by_merchant_id(merchant_id)
    paid_invoices = invoices.find_all { |invoice| invoice.is_paid_in_full? }

    paid_items = paid_invoices.map do |invoice|
      @se.find_all_invoice_items_by_invoice_id(invoice.id)
    end.flatten

    quants = paid_items.each_with_object(Hash.new(0)) do |invoice_item, counts|
      counts[invoice_item.item_id] += invoice_item.quantity
    end

    max_quantity = quants.max_by { |key, value| value }[1]
    max_items = quants.find_all { |item_id, quantity| quantity == max_quantity }
    items_ids = max_items.map { |item_id, quantity| item_id }
    items_ids.map { |item_id| @se.find_item_by_item_id(item_id) }

  end

  def best_item_for_merchant(merchant_id)
    invoices = @se.find_invoices_by_merchant_id(merchant_id)
    paid_invoices = invoices.find_all { |invoice| invoice.is_paid_in_full? }

    paid_items = paid_invoices.map do |invoice|
      @se.find_all_invoice_items_by_invoice_id(invoice.id)
    end.flatten

    revenue = paid_items.each_with_object(Hash.new(0)) do |invoice_item, count|
      count[invoice_item.item_id] += 
        (invoice_item.unit_price * invoice_item.quantity)
    end

    max_revenue = revenue.max_by { |key, value| value }[1]
    max_item = revenue.find { |item_id, revenue| revenue == max_revenue }
    @se.find_item_by_item_id(max_item[0])
  end

end
