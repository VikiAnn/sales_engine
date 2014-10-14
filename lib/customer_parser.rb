require 'csv'
require_relative 'customer'

class CustomerParser
  attr_reader :customers

  def initialize(repository, filepath)
    data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_customer_objects(repository, data)
  end

  def create_customer_objects(repository, customer_data)
    @customers = customer_data.collect do |customer_data|
      customer_data[:id] = customer_data[:id].to_i
      Customer.new(repository, customer_data)
    end
  end
end
