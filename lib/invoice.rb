require "time"

class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at

  def initialize(row, invoice_repository)
    @id = row[:id].to_i
    @customer_id = row[:customer_id].to_i
    @merchant_id = row[:merchant_id].to_i
    @status = row[:status].to_sym
    @created_at = Time.parse(row[:created_at])
    @updated_at = Time.parse(row[:updated_at])
    @invoice_repository = invoice_repository
  end

  def merchant
    @invoice_repository.find_merchant_by_merchant_id(@merchant_id)
  end

  def items
    @invoice_repository.find_items_by_invoice_id(@id)
  end

  def transactions
    @invoice_repository.find_transactions_by_invoice_id(@id)
  end

  def customer
    @invoice_repository.find_customer_by_customer_id(@customer_id)
  end

  def is_paid_in_full?
    @invoice_repository.is_invoice_paid_in_full?(@id)
  end

  def total
    @invoice_respository.find_total_dollar_amount_for_invoice(@id)
  end

end
