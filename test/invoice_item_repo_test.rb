require "minitest/autorun"
require "minitest/emoji"
require "./lib/invoice_item_repo"

class InvoiceItemRepoTest < Minitest::Test

  def setup
    @repo = InvoiceItemRepo.new("./fixtures/invoice_items_fixture.csv")
  end

  def test_invoice_items_repo_exists
    assert @repo
  end

  def test_if_repo_contains_invoice_items

  end

end
