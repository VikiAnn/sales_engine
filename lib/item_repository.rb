class ItemRepository
  attr_reader :items,
              :engine

  def initialize(engine, items = [])
    @engine = engine
    @items  = items
  end

  [:id, :name, :description, :price, :merchant_id, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      items.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end

  [:id, :name, :description, :price, :merchant_id, :created_at, :updated_at].each do |attribute|
    define_method("find_all_by_#{attribute}") do |attribute_value|
      items.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
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

  def inspect
    "#<#{self.class} #{items.size} rows>"
  end

end
