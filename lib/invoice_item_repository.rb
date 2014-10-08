require_relative 'find'

class InvoiceItemRepository
  include Find

  attr_reader :invoice_items,
              :engine

  def initialize(engine, invoice_items = [])
    @engine        = engine
    @invoice_items = invoice_items
    Find.find_by_generator(invoice_items)
    Find.find_all_by_generator(invoice_items)
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
end
