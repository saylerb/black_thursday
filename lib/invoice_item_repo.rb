require "csv"
require_relative "invoice_item"

class InvoiceItemRepo

  def initialize(file_name = "./data/invoice_items.csv", sales_engine = nil)
    @all_invoice_items = load_csv(file_name) unless file_name.nil?
    @sales_engine = sales_engine
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol
    contents.map do |row|
      InvoiceItem.new(row, self)
    end

  end

  def all
    @all_invoice_items
  end

  def find_by_id(id)
    @all_invoice_items.find do |invoice_item|
      invoice_item.id == id
    end
  end

  def find_all_by_item_id(item_id)
    @all_invoice_items.find_all do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @all_invoice_items.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

end
