require "minitest/autorun"
require "minitest/emoji"
require "./lib/invoice_item"
require "time"
require "bigdecimal"

class InvoiceItemTest < Minitest::Test

  def setup
    @invoice = InvoiceItem.new({:id => "1",
                                :item_id => "263519844",
                                :invoice_id => "1",
                                :quantity => "5",
                                :unit_price => "13635",
                                :created_at => "2012-03-27 14:54:09 UTC",
                                :updated_at => "2012-03-27 14:54:09 UTC"}, nil)
  end

  def test_invoice_items_repo_exists
    assert @invoice
  end

  def test_invoice_has_attributes
    assert_equal 1, @invoice.id
    assert_equal 263519844, @invoice.item_id
    assert_equal 1, @invoice.invoice_id
    assert_equal 5, @invoice.quantity
    assert_equal BigDecimal.new(13635)/100, @invoice.unit_price
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"), @invoice.created_at
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"), @invoice.updated_at
  end

end
