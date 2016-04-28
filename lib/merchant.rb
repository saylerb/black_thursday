require 'time'

class Merchant

  attr_reader :id, :name, :created_at

  def initialize(row, merchant_repository)
    @id = row[:id].to_i
    @name = row[:name]
    @created_at = Time.parse(row[:created_at]) unless row[:created_at].nil?
    @merchant_repository = merchant_repository

  end

  def items
    @merchant_repository.find_items_by_merchant_id(@id)
  end

  def invoices
    @merchant_repository.find_invoices_by_merchant_id(@id)
  end

  def customers
    @merchant_repository.find_customer_by_merchant_id(@id)
  end

  def total_items
    items.length
  end

  def total_invoices
    invoices.length
  end

end
