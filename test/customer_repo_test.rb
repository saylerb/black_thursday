require "minitest/autorun"
require "minitest/emoji"
require "./test/test_helper"
require "./lib/customer_repo"

class CustomeRepoTest < Minitest::Test

  def setup
    @repo = CustomerRepo.new("./fixtures/customers_sample.csv")
  end

  def test_custumer__repo_exists
    assert @repo
  end

  def test_if_repo_returns_all_customers
    assert_equal 100, @repo.all.length
  end

  def test_that_repo_can_find_by_customer_id
    assert_kind_of Customer, @repo.find_by_id(94)
    assert_equal "Dusty", @repo.find_by_id(94).first_name
  end

  def test_that_repo_can_find_all_by_first_name
    result = @repo.find_all_by_first_name("Einar")

    assert_kind_of Array, result
    assert_equal 2, result.length
    assert_kind_of Customer, result[0]
    assert_kind_of Customer, result[1]
  end

  def test_that_repo_can_find_all_by_last_name
    result_1 = @repo.find_all_by_last_name("Pfannerstill")
    result_2 = @repo.find_all_by_last_name("Dickens")

    assert_equal 3, result_1.length
    assert_equal 2, result_2.length
  end

  def test_repo_returns_nil_if_it_cannot_find_single_thing
    assert_nil @repo.find_by_id(121239192)
  end

  def test_repo_returns_empty_array_if_it_cannot_find_all_things
    assert_equal [], @repo.find_all_by_first_name("Brian")
    assert_equal [], @repo.find_all_by_last_name("Sayler")
  end

end
