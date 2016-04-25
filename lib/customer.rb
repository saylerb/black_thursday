require "bigdecimal"
require "time"

class Customer

  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at

  def initialize(row, customer_repository)
    @id = row[:id].to_i
    @first_name = row[:first_name]
    @last_name = row[:last_name]
    @created_at = Time.parse(row[:created_at])
    @updated_at = Time.parse(row[:updated_at])

    @customer_repo = customer_repository
  end

end
