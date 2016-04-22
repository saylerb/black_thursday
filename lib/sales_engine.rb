require "csv"
require_relative "merchant_repo"
require_relative "item_repo"
require_relative "invoice_repo"

class SalesEngine
  attr_accessor :merchants, :items, :invoices

  def initialize(file_names)
    @merchants = MerchantRepo.new(file_names[:merchants], self)
    @items = ItemRepo.new(file_names[:items], self)
    @invoices = InvoiceRepo.new(file_names[:invoices], self)
  end

  def self.from_csv(file_names)
    SalesEngine.new(file_names)
  end

  def find_merchant_by_merchant_id(merchant_id)
    @merchants.find_by_id(merchant_id)
  end

  def find_items_by_merchant_id(merchant_id)
    @items.find_all_by_merchant_id(merchant_id)
  end
end
