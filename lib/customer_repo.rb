require "csv"
require_relative "customer"

class CustomerRepo

  def initialize(file_name = "./fixtures/customers_sample.csv",
                 sales_engine = nil)
    @all_customers = load_csv(file_name) unless file_name.nil?
    @sales_engine = sales_engine
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol
    contents.map do |row|
      Customer.new(row, self)
    end
  end

  def size
    @all_customers.length
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
