require "bigdecimal"
require "time"

class InvoiceItem

  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(row, invoice_item_repository)
    @id = row[:id].to_i
    @item_id = row[:item_id].to_i
    @invoice_id = row[:invoice_id].to_i
    @quantity = row[:quantity].to_i
    @unit_price = BigDecimal.new(row[:unit_price])/100
    @created_at = Time.parse(row[:created_at])
    @updated_at = Time.parse(row[:updated_at])

    @invoice_item_repo = invoice_item_repository
  end

end
