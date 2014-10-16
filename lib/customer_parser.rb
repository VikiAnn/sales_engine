require 'csv'
require_relative 'customer'

class CustomerParser
  attr_reader :customers

  def initialize(repository, filepath)
    @filepath = filepath
    create_customer_objects(repository)
  end

  def create_customer_objects(repository)
    @customers = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :numeric }

    CSV.foreach(@filepath, csv_options) do |row|
      @customers << Customer.new(repository, row)
    end
  end
end
