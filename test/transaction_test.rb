require "minitest/autorun"
require "minitest/pride"
require "./lib/transaction"
require "csv"
require "bigdecimal"

class TransactionTest < Minitest::Test

  def setup
    @time = "2007-06-04 21:35:10 UTC"
    @t = Transaction.new({
      :id => 6,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => @time,
      :updated_at => @time
      }, nil)
    end

  def test_it_exists
    assert @t
  end

  def test_it_has_attributes
    assert_equal 6, @t.id
    assert_equal 8, @t.invoice_id
    assert_equal 4242424242424242, @t.credit_card_number
    assert_equal "0220", @t.credit_card_expiration_date
    assert_equal "success", @t.result
    assert_equal Time.parse(@time), @t.created_at
    assert_equal Time.parse(@time), @t.updated_at
  end

  # def test_it_returns_merchant_from_transaction
  #   assert_equal
  # end
end
