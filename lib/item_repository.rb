require_relative 'find'
class ItemRepository
  include Find

  attr_reader :items
  def initialize(items = [])
    @items = items
    Find.find_by_generator(items)
    Find.find_all_by_generator(items)
  end

  def all
    items
  end

  def random
    items.sample
  end

  # [:id, :name, :description, :price, :merchant_id, :created_at, :updated_at].each do |attribute|
  #   define_method("find_by_#{attribute}") do |attribute_value|
  #     items.find { |item| item.send(attribute) == attribute_value.downcase }
  #   end
  # end
  #
  # [:id, :name, :description, :price, :merchant_id, :created_at, :updated_at].each do |attribute|
  #   define_method("find_all_by_#{attribute}") do |attribute_value|
  #     items.select { |item| item.send(attribute) == attribute_value.downcase }
  #   end
  # end

end
