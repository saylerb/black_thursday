require "csv"
require_relative "transaction"

class TransactionRepo

  attr_reader :all_transactions, :sales_engine

  def initialize(file_name, sales_engine)
    @all_transactions = load_csv(file_name)
    @sales_engine = sales_engine
  end

  def load_csv(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol

    result = contents.map do |row|
      Transaction.new(row, self)
    end
    result
  end

  def all
    @all_transactions
  end

  def find_by_id(id)
    @all_transactions.find do |transaction|
      transaction.id == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @all_transactions.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @all_transactions.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    @all_transactions.find_all do |transaction|
      transaction.result.downcase == result.downcase
    end
  end

  def find_invoice_by_invoice_id(invoice_id)
    @sales_engine.find_invoice_by_invoice_id(invoice_id)
  end

end
