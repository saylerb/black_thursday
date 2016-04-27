require "minitest/autorun"
require "minitest/pride"
require "./test/test_helper"
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
      :updated_at  => @time}, InvoiceRepository.new)
  end

  def test_it_exists
    assert @invoice
  end

  def test_that_dates_are_converted_to_time_objects
    assert_kind_of Time, @invoice.created_at
    assert_kind_of Time, @invoice.updated_at
  end

  def test_it_can_find_associated_invoice_items

    @invoice.all_invoice_items

  end

end
