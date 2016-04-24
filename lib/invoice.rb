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

end
