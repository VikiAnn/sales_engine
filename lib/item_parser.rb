require 'csv'
require 'bigdecimal'
require_relative 'item'

class ItemParser
  attr_reader :items

  def initialize(repository, filepath)
    @filepath = filepath
    create_item_objects(repository)
  end

  def create_item_objects(repository)
    @items = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :numeric }

    CSV.foreach(@filepath, csv_options) do |row|
      row[:unit_price] = BigDecimal.new(row[:unit_price].to_s)
      @items << Item.new(repository, row)
    end
  end
end
