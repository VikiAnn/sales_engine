require 'csv'
require_relative 'merchant'

class MerchantParser
  attr_reader :merchants
  def initialize(repository, filepath)
    data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_merchant_objects(repository, data)
  end

  def create_merchant_objects(repository, merchant_data)
    @merchants = merchant_data.collect do |merchant_data|
      merchant_data[:id] = merchant_data[:id].to_i
      Merchant.new(repository, merchant_data)
    end
  end
end
