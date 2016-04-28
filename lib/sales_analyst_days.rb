module SalesAnalystDays

  def invoices_to_days
    @se.all(:@invoices).map { |invoice| invoice.created_at.strftime("%A") }
  end

  def count_invoices_by_day
    Date::DAYNAMES.map { |day| invoices_to_days.count(day) }
  end

  def average_invoices_per_day
    @se.repo_size(:@invoices) / 7
  end

  def top_days_grouped_by_count
    zipped = Date::DAYNAMES.zip(count_invoices_by_day)
    zipped.reduce({}) do |result, sub_array|
      result[sub_array[0]] = sub_array[1]; result
    end
  end

  def top_days_by_invoice_count
    invoice_std = invoices_per_day_standard_deviation
    cutoff = average_invoices_per_day + invoice_std
    Date::DAYNAMES.find_all do |day|
      top_days_grouped_by_count[day] > cutoff
    end
  end

end
