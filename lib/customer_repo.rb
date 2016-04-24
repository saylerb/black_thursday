require "csv"
require_relative "customer"

class CustomerRepo

  def initialize(file_name = "./fixtures/customers_sample.csv", sales_engine = nil)
    @all_customers = load_csv(file_name)
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol
    contents.map do |row|
      Customer.new(row, self)
    end
  end

  def all
    @all_customers
  end

  def find_by_id(id)
    @all_customers.find do |customer|
      customer.id == id
    end
  end

  def find_all_by_first_name(first_name)
    @all_customers.find_all do |customer|
      customer.first_name.downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    @all_customers.find_all do |customer|
      customer.last_name.downcase.include?(last_name.downcase)
    end
  end

end
