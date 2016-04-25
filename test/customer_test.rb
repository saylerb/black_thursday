require "minitest/autorun"
require "minitest/emoji"
require "./test/test_helper"
require "./lib/customer"
require "time"
require "bigdecimal"

class CustomerTest < Minitest::Test

  def setup
    @customer = Customer.new({:id => "94",
                                :first_name => "Dusty",
                                :last_name => "Sanford",
                                :created_at => "2012-03-27 14:54:32 UTC",
                                :updated_at => "2012-03-27 14:54:32 UTC"}, nil)
  end

  def test_invoice_items_repo_exists
    assert @customer
  end

  def test_invoice_has_attributes
    assert_equal 94, @customer.id
    assert_equal "Dusty", @customer.first_name
    assert_equal "Sanford", @customer.last_name
    assert_equal Time.parse("2012-03-27 14:54:32 UTC"), @customer.created_at
    assert_equal Time.parse("2012-03-27 14:54:32 UTC"), @customer.updated_at
  end

end
