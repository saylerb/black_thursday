require "./test/test_helper"
require "minitest/autorun"
require "minitest/pride"
require "./lib/transaction_repo"
require "csv"


class TransactionRepoTest < Minitest::Test

  def setup
    @repo = TransactionRepo.new("./data/transactions_sample.csv", nil)
  end

  def test_repo_exists
    assert @repo
  end

  def test_if_it_can_load_all_transactions
    all_transactions = @repo.all
    assert_kind_of Array, all_transactions
    assert_equal 100, all_transactions.length #4985 in live data
  end

  def test_if_transaction_array_created
    assert_equal Array, @repo.all_transactions.class
  end

  def test_it_loads_transaction_objects
    assert_kind_of Transaction, @repo.all_transactions[0]
  end

  def test_it_finds_transaction_by_transaction_id
    assert_kind_of Transaction, @repo.find_by_id(1)
    assert_equal 2179, @repo.find_by_id(1).invoice_id
  end

  def test_if_finds_all_matches_by_invoice_id
    assert_kind_of Array, @repo.find_all_by_invoice_id(3477)
    assert_equal 2, @repo.find_all_by_invoice_id(3477).length
  end

  def test_it_finds_all_transactions_by_credit_card_number
    assert_equal 4068631943231473, @repo.find_by_id(1).credit_card_number
  end

  def test_it_finds_all_by_credit_card_number
    trans = @repo.find_all_by_credit_card_number(4068631943231473)
    assert_kind_of Array, trans
    assert_equal 1, trans.first.id
  end

  def test_it_finds_all_transactions_by_result
    assert_equal 77, @repo.find_all_by_result("success").count
    assert_equal 23, @repo.find_all_by_result('failed').count
  end
end
