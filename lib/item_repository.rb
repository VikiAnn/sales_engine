class ItemRepository
  ITEM_ATTRIBUTES = [ :id,
                      :name,
                      :description,
                      :merchant_id,
                      :created_at,
                      :updated_at ]

  attr_reader :items,
              :engine

  def initialize(engine, items = [])
    @engine = engine
    @items  = items
  end

  def load(filepath)
    @items = ItemParser.new(self, filepath).items
  end

  ITEM_ATTRIBUTES.each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      items.find do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      items.select do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end
  end

  def find_by_unit_price(price)
    items.find do |item|
      BigDecimal.new(item.unit_price) == (BigDecimal.new(price)*100)
    end
  end

  def find_all_by_unit_price(price)
    items.select do |item|
      BigDecimal.new(item.unit_price) == (BigDecimal.new(price)*100)
    end
  end

  def all
    items
  end

  def most_revenue(number_of_results)
    items_by_revenue[0..(number_of_results-1)]
  end

  def items_by_revenue
    items.sort_by { |item| -item.total_revenue }
  end
  
  def most_items(number_of_results)
    items.sort_by{|item| -item.total_sold}[0..(number_of_results-1)]
  end

  def random
    items.sample
  end

  def find_invoice_items(item_id)
    engine.find_invoice_items_by_item_id(item_id)
  end

  def find_merchant(merchant_id)
    engine.find_by_merchant(merchant_id)
  end

  def inspect
    "#<#{self.class} #{items.size} rows>"
  end
end
