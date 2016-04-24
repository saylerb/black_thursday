require "minitest/autorun"
require "minitest/emoji"
require "./lib/invoice_item"

class InvoiceItemTest < Minitest::Test

  def setup
    @invoice = InvoiceItem.new({:id => "1",
                                :item_id => "263519844",
                                :invoice_id => "1",
                                :quantity => "5",
                                :unit_price => "13635",
                                :created_at => "2012-03-27 14:54:09 UTC",
                                :updated_at => "2012-03-27 14:54:09 UTC"})
  end

  def test_invoice_items_repo_exists
    assert @invoice
  end

end
