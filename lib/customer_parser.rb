require 'csv'
require_relative 'customer'

class CustomerParser
  attr_reader :customers

  def initialize(repository, filepath)
    customer_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_customer_objects(repository, customer_data)
  end

  def create_customer_objects(repository, customer_data)
    @customers = customer_data.collect do |customer_data|
      Customer.new(repository, customer_data)
    end
  end
end
