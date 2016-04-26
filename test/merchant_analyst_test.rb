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
    date = Time.parse("2013-06-18")
    assert_kind_of BigDecimal, @sa.total_revenue_by_date(date)
    assert_equal 2838.84, @sa.total_revenue_by_date(date).to_f
  end

  def test_it_finds_top_20_performing_merchants
    assert_equal 20, @sa.top_revenue_earners.length 
    assert_equal 12334634, @sa.top_revenue_earners.first.id
  end
end
