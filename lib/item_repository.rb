class ItemRepository
  attr_reader :items,
              :engine

  def initialize(engine, items = [])
    @engine = engine
    @items  = items
  end

  [:id, :name, :description, :merchant_id, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      items.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      items.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end

  def find_by_unit_price(price)
    items.find { |item| BigDecimal.new(item.unit_price) == (BigDecimal.new(price)*100)  }
  end

  def find_all_by_unit_price(price)
    items.select { |item| BigDecimal.new(item.unit_price) == (BigDecimal.new(price)*100) }
  end

  def all
    items
  end

  def most_revenue(number_of_results)
    items_by_revenue = items.sort_by { |item| -item.total_revenue }
    items_by_revenue[0..(number_of_results-1)]
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
