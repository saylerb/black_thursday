require "minitest/autorun"
require "minitest/pride"
require "./test/test_helper"
require "csv"
require "./lib/invoice_repo"

class InvoiceRepoTest < Minitest::Test

  def setup
    @repo = InvoiceRepo.new("./data/invoices.csv", nil)
  end

  def test_it_exists
    assert @repo.all
  end

  def test_if_merchants_array_created
    assert_equal Array, @repo.all.class
  end

  def test_it_finds_invoice_by_invoice_id
    assert @repo.find_by_id(2).id
  end

  def test_if_finds_invoice_by_customer_id
    @repo.find_all_by_customer_id(2).all? do |invoice|
      invoice.id == Fixnum
    end
  end

  def test_it_finds_all_invoices_by_merchant_id
    result = @repo.find_all_by_merchant_id(12334123).all? do |invoice|
      invoice.class == Invoice
    end
    assert result
  end

  def test_it_finds_by_status
    total = @repo.all.length
    pending = @repo.find_all_by_status("pending").length
    returned = @repo.find_all_by_status("returned").length
    shipped = @repo.find_all_by_status("shipped").length
    assert total, pending + returned + shipped
  end


end
