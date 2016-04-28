require "csv"
require_relative "invoice"

class InvoiceRepo

  attr_reader :all_invoices, :sales_engine

  def initialize(file_name, sales_engine)
    @all_invoices = load_csv(file_name)
    @sales_engine = sales_engine
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol

    result = contents.map do |row|
      Invoice.new(row, self)
    end
    result
  end

  def size
    @all_invoices.length
  end

  def all
    @all_invoices
  end

  def find_by_id(id)
    @all_invoices.find do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    @all_invoices.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @all_invoices.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    @all_invoices.find_all do |invoice|
      invoice.status.downcase == status.downcase
    end
  end

  def total_invoices_for_status(status)
    find_all_by_status(status).length
  end

  def find_merchant_by_merchant_id(merchant_id)
    @sales_engine.find_merchant_by_merchant_id(merchant_id)
  end

  def find_items_by_invoice_id(invoice_id)
    @sales_engine.find_items_by_invoice_id(invoice_id)
  end

  def find_transactions_by_invoice_id(id)
    @sales_engine.find_transactions_by_invoice_id(id)
  end

  def find_customer_by_customer_id(id)
    @sales_engine.find_customer_by_customer_id(id)
  end

  def is_invoice_paid_in_full?(invoice_id)
    @sales_engine.is_invoice_paid_in_full?(invoice_id)
  end

  def find_total_dollar_amount_for_invoice(invoice_id)
    @sales_engine.find_total_dollar_amount_for_invoice(invoice_id)
  end

end
