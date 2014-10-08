require_relative 'find'

class ItemRepository
  include Find

  attr_reader :items,
              :engine

  def initialize(engine, items = [])
    @engine = engine
    @items  = items
    Find.find_by_generator(items)
    Find.find_all_by_generator(items)
  end

  def all
    items
  end

  def random
    items.sample
  end

  def find_invoice_items(item_id)
    engine.find_invoice_items_by_item_id(item_id)
  end

  def find_merchant(merchant_id)
    engine.find_merchant_by_merchant_id(merchant_id)
  end

end
