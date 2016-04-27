require "./test/test_helper"
require "minitest/autorun"
require "minitest/pride"
require "./lib/sales_analyst"
require "./lib/sales_engine"
require "time"

class MerchantAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices  => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_calculates_total_for_date_
    skip
    date = Time.parse("2013-06-18")
    assert_kind_of BigDecimal, @sa.total_revenue_by_date(date)
    assert_equal 2838.84, @sa.total_revenue_by_date(date).to_f
  end

  def test_it_finds_top_20_performing_merchants
    skip
    assert_equal 20, @sa.top_revenue_earners.length 
    assert_equal 12334634, @sa.top_revenue_earners.first.id
  end


  def test_finds_most_sold_item_for_merchant
    skip
    @sa.most_sold_item_for_merchant(12337105)
  end

  def test_finding_all_invoice_items_for_merchant
    # Find all invoice items for specific merchant id
    # merchant = MerchantRepo.new(
    best_item = @sa.best_item_for_merchant(12337105)
    
   # .merchants.find_by_id(12337105)

    assert_kind_of InvoiceItem, best_item
    assert_equal 12, best_item

  end

  def test_finding_revenue_for_all_items
    skip
    # Map item revenues and item id numbers to hash from invoice items array
  end
  
  def test_finding_object_with_object_id
    skip
    # Find max revenue item object with item id number
  end

end
