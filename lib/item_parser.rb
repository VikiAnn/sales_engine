require 'csv'
require 'bigdecimal'
require_relative 'item'

class ItemParser
  def initialize(repository, filepath)
    item_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_item_objects(repository, item_data)
  end

  def create_item_objects(repository, item_data)
    item_data.collect do |item_data|
      item_data[:unit_price] = BigDecimal.new(item_data[:unit_price].to_s)
      Item.new(repository, item_data)
    end
  end
end
