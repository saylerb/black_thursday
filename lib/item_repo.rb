require_relative "item"
require "pry"

class ItemRepo

  attr_reader :all_items, :sales_engine

  def initialize(file_name, sales_engine)
    @all_items = load_csv(file_name) unless file_name.nil?
    @sales_engine = sales_engine
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol

    contents.map do |row|
      Item.new({:id => row[:id],
                :name => row[:name],
                :description => row[:description],
                :unit_price => row[:unit_price],
                :merchant_id => row[:merchant_id],
                :created_at => row[:created_at],
                :updated_at => row[:updated_at]}, self)
    end
  end

  def all
    @all_items
  end

  def find_by_id(id)
    @all_items.find do |item|
      item.id == id
    end
  end

  def find_by_name(name)
    @all_items.find do |item|
      item.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name)
    @all_items.find_all do |item|
      item.name.downcase.include?(name.downcase)
    end
  end

  def find_all_with_description(description)
    @all_items.find_all do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(unit_price)
    @all_items.find_all do |item|
      item.unit_price == unit_price
    end
  end

  def find_all_by_price_in_range(range)
    @all_items.find_all do |item|
      range.include?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @all_items.find_all do |item|
      item.merchant_id == merchant_id
    end
  end

  def find_merchant_by_merchant_id(merchant_id)
    @sales_engine.find_merchant_by_merchant_id(merchant_id)
  end

end
