module SalesCalculator

  def average(numerator, denominator)
    (numerator/denominator).round(2)
  end

  def average_items_per_merchant
    average(@total_items.to_f, @se.merchants.all.length)
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
    total_items = @se.merchants.find_by_id(merchant_id).items.length
    total_price = @se.merchants.find_by_id(merchant_id).items.reduce(0) do |sum, item|
      sum += item.unit_price
    end
    (total_price / total_items).round(2)
  end

 
end
