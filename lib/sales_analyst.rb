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
    cutoff = @mean_merchant_items + average_items_per_merchant_standard_deviation
    @all_merchants.find_all do |merchant|
      merchant.items.length > cutoff
    end
  end

  def golden_items
    price_std = price_standard_deviation
    cutoff = @mean_item_price + ((price_std) * 2)
    @all_items.find_all { |item| item.unit_price > cutoff }
  end

  def top_merchants_by_invoice_count
    invoice_std = invoice_standard_deviation
    cutoff = @mean_merchant_invoices + ((invoice_std) * 2)
    @all_merchants.find_all do |merchant|
      merchant.invoices.length > cutoff
    end
  end

  def bottom_merchants_by_invoice_count
    invoice_std = invoice_standard_deviation
    cutoff = @mean_merchant_invoices - ((invoice_std) * 2)
    @se.merchants.all.find_all do |merchant|
      merchant.invoices.length < cutoff
    end
  end

  def top_revenue_earners(number = 20)
    all_invoices = @se.merchants.all.map do |merchant|
      merchant.invoices
    end

    totals = all_invoices.map do |invoices|
      invoices.map { |invoice| invoice.total }.reduce(:+)
    end

    sorted = @se.merchants.all.zip(totals).sort_by do |pair|
      -pair[1]
    end

    sorted[0...number].map { |pair| pair[0] }
  end

  def merchants_ranked_by_revenue
    top_revenue_earners(@total_merchants)
  end

  def merchants_with_pending_invoices
    unpaid_invoices = @se.invoices.all.find_all do |invoice|
      !invoice.is_paid_in_full?
    end

    merchants_with_unpaid_invoices = unpaid_invoices.map do |invoice|
      invoice.merchant
    end

    merchants_with_unpaid_invoices.uniq
  end

  def merchants_with_only_one_item
    @se.merchants.all.find_all do |merchant|
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
    invoices = @se.merchants.find_invoices_by_merchant_id(merchant_id)

    invoices.reduce(0) do |sum, invoice|
      sum += invoice.total; sum
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    invoices = @se.merchants.find_invoices_by_merchant_id(merchant_id)

    paid_invoices = invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end

    paid_invoice_items = paid_invoices.map do |invoice|
      @se.invoice_items.find_all_by_invoice_id(invoice.id)
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
      @se.items.find_by_id(item_id)
    end

    result

  end

  def best_item_for_merchant(merchant_id)
    invoices = @se.merchants.find_invoices_by_merchant_id(merchant_id)

    paid_invoices = invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end

    paid_invoice_items = paid_invoices.map do |invoice|
      @se.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten

    item_revenues = paid_invoice_items.each_with_object(Hash.new(0)) do |invoice_item, counts|
      counts[invoice_item.item_id] += (invoice_item.unit_price * invoice_item.quantity)
    end

    max_revenue = item_revenues.max_by { |key, value| value }[1]

    max_item = item_revenues.find do |item_id, revenue|
      revenue == max_revenue
    end

    @se.items.find_by_id(max_item[0])

  end


end
