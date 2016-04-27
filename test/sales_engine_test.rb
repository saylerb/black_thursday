require "minitest/autorun"
require "minitest/pride"
require "./test/test_helper"
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
    merchant_one = se.merchants.find_by_id(12334105)
    assert_kind_of Merchant, merchant_one
    assert_kind_of Array, merchant_one.customers
    assert_kind_of Customer, merchant_one.customers[0]
    assert_equal 10, merchant_one.customers.length

    merchant_two = se.merchants.find_by_id(12334194)
    assert_kind_of Merchant, merchant_two
    assert_kind_of Array, merchant_two.customers
    assert_kind_of Customer, merchant_two.customers[0]
    assert_equal 12, merchant_two.customers.length
  end

  def test_it_can_find_out_if_invoice_is_paid_in_full
    invoice_one = se.invoices.find_by_id(1)
    invoice_two = se.invoices.find_by_id(204)

    assert invoice_one.is_paid_in_full?
    refute invoice_two.is_paid_in_full?
  end

  def test_it_can_find_total_dollar_amount_for_invoice
    invoice = se.invoices.all.first
    assert_kind_of BigDecimal, invoice.total
  end

  def test_can_get_invoice_for_transaction
    trans = se.transactions.find_by_id(1)
    invoice = trans.invoice

    assert_kind_of Transaction, trans
    assert_equal invoice.id, trans.invoice_id

  end


end
