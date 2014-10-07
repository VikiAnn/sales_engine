require_relative 'find'

class InvoiceItemRepository
  include Find

  attr_reader :invoice_items
  def initialize(invoice_items = [])
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

end
