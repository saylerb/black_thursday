require "minitest/autorun"
require "minitest/emoji"
require "./lib/invoice_item_repo"

class InvoiceItemRepoTest < Minitest::Test

  def setup
    @ip = InvoiceItemRepo.new
  end

  def test_invoice_items_repo_exists
    assert @ip
  end

  def test_invoice_item_has_attributes
  end

end
