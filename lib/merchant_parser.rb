require 'csv'
require_relative 'merchant'

class MerchantParser
  attr_reader :merchants
  def initialize(repository, filepath)
    merchant_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_merchant_objects(repository, merchant_data)
  end

  def create_merchant_objects(repository, merchant_data)
    @merchants = merchant_data.collect do |merchant_data|
      Merchant.new(repository, merchant_data)
    end
  end
end
