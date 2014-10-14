class InvoiceItemRepository
  attr_reader   :engine,
                :invoice_items


  def initialize(engine, invoice_items = [])
    @engine        = engine
    @invoice_items = invoice_items
  end

  def load(filepath)
    @invoice_items = InvoiceItemParser.new(self, "#{filepath}/invoice_items.csv").invoice_items
  end

  [:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      invoice_items.find do |object|
        object.send(attribute).to_s.downcase == attribute_value.to_s.downcase
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      invoice_items.select do |object|
        object.send(attribute).to_s.downcase == attribute_value.to_s.downcase
      end
    end
  end

  def all
    invoice_items
  end

  def random
    invoice_items.sample
  end

  def find_item(item_id)
    engine.find_item_by_item_id(item_id)
  end

  def find_invoice(invoice_id)
    engine.find_invoice_by_invoice_id(invoice_id)
  end

  def inspect
    "#<#{self.class} #{invoice_items.size} rows>"
  end

  def create_invoice_items(invoice_id, items)
    grouped_items = items.group_by { |item| item.id }
    grouped_items.collect do |item_id, items |
      data = { id: invoice_items.last.id.to_i + 1,
               item_id: item_id,
               quantity: items.count,
               invoice_id: invoice_id,
               unit_price: items.first.unit_price,
               created_at: Time.now,
               updated_at: Time.now }
      invoice_items << InvoiceItem.new(self, data)
    end
  end
end
