require_relative 'invoice'

class InvoiceRepository
  attr_reader :engine,
              :invoices

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

  def create(customer:, merchant:, status:, items:)
    data = { id: invoices.last.id.to_i + 1, customer_id: customer.id.to_i, merchant_id: merchant.id.to_i, status: status, created_at: Time.now, updated_at: Time.now }
    invoice = Invoice.new(self, data)
    engine.create_invoice_items(invoice.id, items)
    invoices << invoice
    invoice
  end

  # def create_invoice_items(invoice_id, items)
  #   grouped_items = items.group_by { |item| item.id }
  #   item_ids = grouped_items.keys
  #   invoice_items = grouped_items.collect do |item_id, items |
  #     data = { id: invoice_item_repository.invoice_items.last.id.to_i + 1,
  #              item_id: item_id,
  #              quantity: items.count,
  #              invoice_id: invoice_id,
  #              unit_price: items.first.unit_price,
  #              created_at: Time.now,
  #              updated_at: Time.now }
  #     InvoiceItem.new(invoice_item_repository, data)
  #   end
  # end
end
