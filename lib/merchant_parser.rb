require 'csv'
require_relative 'merchant'

class MerchantParser
  attr_reader :merchants

  def initialize(repository, filepath)
    @filepath = filepath
    create_merchant_objects(repository)
  end

  def create_merchant_objects(repository)
    @merchants = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :numeric }

    CSV.foreach(@filepath, csv_options) do |row|
      @merchants << Merchant.new(repository, row)
    end
  end
end
