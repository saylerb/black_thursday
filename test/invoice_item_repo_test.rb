require "minitest/autorun"
require "minitest/emoji"
require "./lib/invoice_item_repo"

class InvoiceItemRepoTest < Minitest::Test

  def setup
    @repo = InvoiceItemRepo.new("./fixtures/invoice_items_sample.csv")
  end

  def test_invoice_items_repo_exists
    assert @repo
  end

  def test_if_repo_returns_invoice_items
    assert_equal 100, @repo.all.length
  end

  def test_that_repo_can_find_by_invoice_id
    assert_kind_of InvoiceItem, @repo.find_by_id(10)
    assert_equal 263523644, @repo.find_by_id(10).item_id
  end

  def test_that_repo_can_find_all_by_item_id
    result_1 = @repo.find_all_by_item_id(263529264)
    result_2 =   @repo.find_all_by_item_id(263553176)
    assert_kind_of Array, result_1
    assert_kind_of Array, result_2
    assert_equal 2, result_1.length
    assert_equal 2, result_2.length
    assert_kind_of InvoiceItem, result_1[0]
    assert_kind_of InvoiceItem, result_2[0]
  end

end
