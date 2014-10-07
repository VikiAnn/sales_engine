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

end
