class InvoiceItemRepository
  INVOICE_ITEM_ATTRIBUTES = [ :id,
                              :item_id,
                              :invoice_id,
                              :quantity,
                              :unit_price,
                              :created_at,
                              :updated_at ]

  attr_reader   :engine,
                :invoice_items

  def initialize(engine, invoice_items = [])
    @engine        = engine
    @invoice_items = invoice_items
  end

  def load(filepath)
    @invoice_items = InvoiceItemParser.new(self, filepath).invoice_items
  end

  INVOICE_ITEM_ATTRIBUTES.each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      invoice_items.find do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      invoice_items.select do |object|
        object.send(attribute).to_s.downcase == attribute_value
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

  def group(items)
    items.group_by { |item| item.id }
  end

  def create_invoice_items(invoice_id, items)
    group(items).collect do |item_id, items |
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
