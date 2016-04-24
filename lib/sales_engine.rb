require "csv"
require_relative "merchant_repo"
require_relative "item_repo"
require_relative "invoice_repo"
require_relative "invoice_item_repo"
require_relative "transaction_repo"
require_relative "customer_repo"

class SalesEngine
  attr_accessor :merchants,
                :items,
                :invoices,
                :invoice_items,
                :transactions,
                :customers

  def initialize(file_names)
    @merchants = MerchantRepo.new(file_names[:merchants], self)
    @items = ItemRepo.new(file_names[:items], self)
    @invoices = InvoiceRepo.new(file_names[:invoices], self)
    @invoice_items = InvoiceItemRepo.new(file_names[:invoice_items], self)
    @transactions = TransactionRepo.new(file_names[:transactions], self)
    @customers = CustomerRepo.new(file_names[:customers], self)

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

  def find_invoices_by_merchant_id(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id)
  end

  def find_items_by_invoice_id(invoice_id)
    invoice_items = @invoice_items.find_all_by_invoice_id(invoice_id) # => [Invoice_Item_1, Invoice_Item_2]
    invoice_items.map do |invoice_item|
      @items.find_by_id(invoice_item.item_id)
    end
  end



  # end

  # def find_transactions_by_merchant_id(merchant_id)
  #   @transactions.find_all_by_merchant_id(merchant_id)
  # end


end
