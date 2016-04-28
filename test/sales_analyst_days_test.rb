require "./test/test_helper"
require "minitest/autorun"
require "minitest/pride"
require "./lib/sales_analyst"
require "./lib/sales_engine"

class SalesAnalystDaysTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices  => "./data/invoices.csv"})
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_converts_dates_to_day_of_week
    assert @sa.invoices_to_days.include?("Monday")
  end

  def test_create_hash_with_day_counts
    assert_kind_of Hash, @sa.top_days_grouped_by_count
  end

  def test_it_calculates_average_invoices_per_day
    assert 712, @sa.average_invoices_per_day.round
  end

  def test_it_calculates_std_deviation_of_invoices_per_day
    assert 18.06, @sa.invoices_per_day_standard_deviation
  end

  def test_it_converts_thing_to_hash
    assert_equal ({"Monday" => 696,
                  "Tuesday" => 692,
                  "Wednesday" => 741,
                  "Thursday" => 718,
                  "Friday" => 701,
                  "Saturday" => 729,
                  "Sunday" => 708}), @sa.top_days_grouped_by_count
  end

  def test_it_returns_days_1_std_above_mean
    days = ["Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday"]
    assert days.include?(@sa.top_days_by_invoice_count[0])
  end

  def test_grouping_invoices_by_status
    assert_kind_of Hash, @sa.group_invoices_by_status
  end

  def test_it_calculates_percentage_of_invoices_with_given_status
    assert_equal 29.55, @sa.invoice_status(:pending)
    assert_equal 56.95, @sa.invoice_status(:shipped)
    assert_equal 13.50, @sa.invoice_status(:returned)
  end

end
