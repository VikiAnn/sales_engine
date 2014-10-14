require 'csv'
require 'bigdecimal'
require_relative 'item'

class ItemParser
  attr_reader :items
  def initialize(repository, filepath)
    data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_item_objects(repository, data)
  end

  def create_item_objects(repository, item_data)
    @items = item_data.collect do |item_data|
      item_data[:id] = item_data[:id].to_i
      item_data[:unit_price] = BigDecimal.new(item_data[:unit_price].to_s)
      Item.new(repository, item_data)
    end
  end
end
