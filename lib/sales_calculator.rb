module SalesCalculator

  def average(numerator, denominator)
    (numerator/denominator).round(2)
  end

  def average_items_per_merchant
    average(@total_items.to_f, @total_merchants)
  end

  def standard_deviation(average_to_find, repo_name, average, total_population)
    squares = @se.all(repo_name).map do |repo_element|
      (repo_element.send(average_to_find) - average) ** 2
    end
    Math.sqrt(squares.reduce(:+) / (total_population - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(:total_items, :@merchants, @mean_merchant_items, @total_merchants)
  end

  def average_item_price_for_merchant(merchant_id)
    total_items = @se.find_total_number_of_items_for_merchant_id(merchant_id)
    total_price = @se.find_total_dollar_amount_for_merchant_id(merchant_id)

    average(total_price, total_items)
  end

  def average_average_price_per_merchant
    total_averages = @se.all(:@merchants).reduce(0) do |sum, merchant|
      sum += average_item_price_for_merchant(merchant.id); sum
    end
    average(total_averages, @total_merchants)
  end

  def average_item_price
    total_price = @se.all(:@items).reduce(0) do |sum, item|
      sum += item.unit_price
    end
    average(total_price, @total_items)
  end

  def price_standard_deviation
    standard_deviation(:unit_price, :@items, @mean_item_price, @total_items)
  end

  def average_invoices_per_merchant
     average(@total_invoices.to_f, @total_merchants)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(:total_invoices, :@merchants, @mean_merchant_invoices, @total_merchants)
  end

  def invoice_standard_deviation
    standard_deviation(:total_invoices, :@merchants, @mean_merchant_invoices, @total_merchants)
  end
 
  def invoices_per_day_standard_deviation
    squares = count_invoices_by_day.map do |number|
      (number - average_invoices_per_day) ** 2
    end
    Math.sqrt(squares.reduce(:+) / 6).round(2)
  end


end
