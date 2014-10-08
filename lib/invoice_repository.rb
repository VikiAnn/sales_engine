require_relative 'find'

class InvoiceRepository
  include Find

  attr_reader :invoices,
              :engine

  def initialize(engine, invoices = [])
    @engine   = engine
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

  def find_transaction(invoice_id)
    engine.find_all_transactions_by_invoice_id(invoice_id)
  end

  def find_invoice_items(invoice_id)
    engine.find_all_invoice_items_by_invoice_id(invoice_id)
  end

  def find_items_by_invoice_items(invoice_id)
    engine.find_all_items_by_invoice_id(invoice_id)
  end

  def find_by_customer(customer_id)
    engine.find_by_customer(customer_id)
  end

  def find_by_merchant(merchant_id)
    engine.find_by_merchant(merchant_id)
  end

  def inspect
    "#<#{self.class} #{invoices.size} rows>"
  end
end
