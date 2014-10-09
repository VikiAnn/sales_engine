class InvoiceRepository
  attr_reader :invoices,
              :engine

  def initialize(engine, invoices = [])
    @engine   = engine
    @invoices = invoices
  end

  [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      invoices.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      invoices.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

  def find_transactions(invoice_id)
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
