require_relative 'find'

class InvoiceRepository
  include Find

  attr_reader :invoices
  def initialize(invoices = [])
    @invoices = invoices
    Find.find_by_generator(invoices)
    Find.find_all_by_generator(invoices)
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

end
