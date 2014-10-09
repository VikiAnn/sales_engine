class InvoiceItemRepository
  attr_reader :invoice_items,
              :engine

  def initialize(engine, invoice_items = [])
    @engine        = engine
    @invoice_items = invoice_items
  end

  [:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at].each do |attribute|
      define_method("find_by_#{attribute}") do |attribute_value|
        invoice_items.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
      end
    end

  [:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at].each do |attribute|
    define_method("find_all_by_#{attribute}") do |attribute_value|
      invoice_items.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
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
end
