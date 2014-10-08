require 'csv'

class ItemParser
  attr_reader :items

  def initialize(repository, filepath)
    item_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_item_objects(repository, item_data)
  end

  def create_item_objects(repository, item_data)
    @items = item_data.collect do |item_data|
      item_data[:name]        = item_data[:name].to_s.downcase
      item_data[:description] = item_data[:description].to_s.downcase
      item_data[:created_at]  = item_data[:created_at].to_s.downcase
      item_data[:updated_at]  = item_data[:updated_at].to_s.downcase
      Item.new(repository, item_data)
    end
  end
end
