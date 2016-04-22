require "minitest/autorun"
require "minitest/pride"
require "./lib/invoice"
require "csv"
require "bigdecimal"

class InvoiceTest < Minitest::Test

  def setup
    @time = "2007-06-04"
    @invoice = Invoice.new({
      :id          => "6",
      :customer_id => "7",
      :merchant_id => "8",
      :status      => "pending",
      :created_at  => @time,
      :updated_at  => @time}, nil)
  end

  def test_it_exists
    assert @invoice
  end

  def test_it_find_merchant_in_invoice
    puts @invoice.merchant
  end

end
