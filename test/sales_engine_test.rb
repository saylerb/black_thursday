require "minitest/autorun"
require "minitest/pride"
require "./lib/sales_engine"

class SalesEngineTest < Minitest::Test

  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({:items     => "./data/items.csv",
                               :merchants => "./data/merchants.csv",
                               :invoices  => "./data/invoices.csv",
                               :invoice_items => "./data/invoice_items.csv",
                               :transactions => "./data/transactions.csv",
                               :customers => "./data/customers.csv"})
  end

  def test_it_loads_each_repo
    assert se.merchants
    assert se.items
    assert_kind_of Item, se.items.find_by_name("Woodsy Sh!tz Spr!tz")
    assert se.invoices
    assert se.invoice_items
    assert se.transactions
    assert se.customers
  end

  def test_it_can_find_items_for_invoice
    invoice = se.invoices.find_by_id(20)
    # require "pry"; binding.pry
    assert_kind_of Array, invoice.items
    assert_equal 5, invoice.items.length
  end

  def test_it_can_find_transactions_for_invoice
    invoice = se.invoices.find_by_id(20)
    assert invoice.transactions
    assert_kind_of Array, invoice.transactions
    assert_equal 3, invoice.transactions.length
  end

  def test_invoice_has_customer
    invoice = se.invoices.find_by_id(20)
    assert invoice.customer
    assert_kind_of Customer, invoice.customer
  end

  def test_it_can_find_invoice_for_transaction
    transaction = se.transactions.find_by_id(40)
    assert_kind_of Invoice, transaction.invoice
    assert_equal 12335150, transaction.invoice.merchant_id
  end

  def test_it_can_find_customers_for_merchant
    merchant = se.merchants.find_by_id(12334105)
    assert_kind_of Merchant, merchant
    assert_kind_of Array, merchant.customers
    assert_kind_of Customer, merchant.customers[0]
  end

  def test_it_can_find_merchants_for_customer
    merchant = se.merchants.find_by_id(12334194)
    assert_kind_of Merchant, merchant
    assert_kind_of Array, merchant.customers
    assert_kind_of Customer, merchant.customers[0]
    assert_equal 13, merchant.customers.length
  end

  def test_it_can_find_out_if_invoice_is_paid_in_full
    invoice_one = se.invoices.find_by_id(1)
    invoice_two = se.invoices.find_by_id(204)

    assert invoice_one.is_paid_in_full?
    refute invoice_two.is_paid_in_full?
  end

  def test_it_can_find_total_dollar_amount_for_invoice
    invoice = se.invoices.all.first
    puts invoice
    assert invoice.total

  end

end
