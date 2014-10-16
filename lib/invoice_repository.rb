class InvoiceRepository
  INVOICE_REPOSITORY = [ :id,
                         :customer_id,
                         :merchant_id,
                         :status,
                         :created_at,
                         :updated_at ]

  attr_reader :engine,
              :invoices

  def initialize(engine, invoices = [])
    @engine   = engine
    @invoices = invoices
  end

  def load(filepath)
    @invoices = InvoiceParser.new(self, filepath).invoices
  end

  INVOICE_REPOSITORY.each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      invoices.find do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      invoices.select do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
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

  def create(customer:, merchant:, status: "success", items:)
    data = { id: invoices.last.id.to_i + 1,
             customer_id: customer.id.to_i,
             merchant_id: merchant.id.to_i,
             status: status,
             created_at: Time.now,
             updated_at: Time.now }
    invoice = Invoice.new(self, data)
    create_invoice_items(invoice, items)
  end

  def create_invoice_items(invoice, items)
    engine.create_invoice_items(invoice.id, items)
    invoices << invoice
    invoice
  end

  def charge(id, transaction_data)
    engine.create_transaction(id, transaction_data)
  end

  def pending
    invoices.reject(&:paid?)
  end

  def average_revenue(date=nil)
    (find_average(:total, date)/100).round(2)
  end

  def average_items(date=nil)
    find_average(:total_quantity, date).round(2)
  end

  def find_average(attribute, date)
    invoices = date ? invoices_by(date) : paid_invoices
    total = invoices.reduce(0) do |total, invoice|
      total + invoice.send(attribute)
    end
    BigDecimal(total) / invoices.count
  end

  def invoices_by(date)
    paid_invoices.select{|invoice| date == Date.parse(invoice.created_at)}
  end

  def paid_invoices
    invoices.select(&:paid?)
  end

  def inspect
    "#<#{self.class} #{invoices.size} rows>"
  end
end
