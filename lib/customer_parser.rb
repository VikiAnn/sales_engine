require 'csv'

class CustomerParser
  attr_reader :customers

  def initialize(repository, filepath)
    customer_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_customer_objects(repository, customer_data)
  end

  def create_customer_objects(repository, customer_data)
    @customers = customer_data.collect do |customer_data|
      customer_data[:id]          = customer_data[:id]
      customer_data[:first_name]  = customer_data[:first_name].to_s.downcase
      customer_data[:last_name]   = customer_data[:last_name].to_s.downcase
      customer_data[:created_at]  = customer_data[:created_at].to_s.downcase
      customer_data[:updated_at]  = customer_data[:updated_at].to_s.downcase
      Customer.new(repository, customer_data)
    end
  end
end
