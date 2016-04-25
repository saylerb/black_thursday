require "./test/test_helper"
require "minitest/autorun"
require "minitest/pride"
require "./lib/merchant"
require "csv"

class MerchantTest < Minitest::Test

  def test_it_exists
    merch = Merchant.new({:id => 5, :name => "Turing School"}, nil)
    assert merch
  end

  def test_has_name
    merch = Merchant.new({:id => 5, :name => "Turing School"}, nil)
    assert_equal "Turing School", merch.name
  end

  def test_it_has_id
    merch = Merchant.new({:id => 5, :name => "Turing School"}, nil)
    assert_equal 5, merch.id
  end

end
