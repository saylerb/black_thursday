require "csv"
require_relative "invoice_item"

class InvoiceItemRepo

  def initialize(file_name = "./data/invoice_items.csv", sale_engine = nil)
    @all_invoices = load_csv(file_name)
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol
    contents.map do |row|
      InvoiceItem.new(row, self)
    end

  end
end
