require "csv"
require_relative "merchant"

class MerchantRepo
  attr_reader :all_merchants, :sales_engine

  def initialize(file_name, sales_engine)
    @all_merchants = load_csv(file_name)
    @sales_engine = sales_engine
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol

    result = contents.map do |row|
      Merchant.new({:id => row[:id], :name => row[:name]}, self)
    end
    result
  end

  def all
    @all_merchants
  end

  def find_by_id(id)
    @all_merchants.find do |merchant|
      merchant.id == id
    end
  end

  def find_by_name(name)
    @all_merchants.find do |merchant|
      merchant.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name)
    @all_merchants.find_all do |merchant|
      merchant.name.downcase.include?(name.downcase)
    end
  end

  def find_items_by_merchant_id(merchant_id)
    @sales_engine.find_items_by_merchant_id(merchant_id)
  end

  def find_invoices_by_merchant_id(merchant_id)
    @sales_engine.find_invoices_by_merchant_id(merchant_id)
  end

  def find_customer_by_merchant_id(merchant_id)
    @sales_engine.find_customer_by_merchant_id(merchant_id)
  end
end
