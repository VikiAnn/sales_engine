class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @customer_id = data[:customer_id]
    @merchant_id = data[:merchant_id]
    @status      = data[:status]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def transactions
    repository.find_transactions(id)
  end

  def invoice_items
    repository.find_invoice_items(id)
  end

  def items
    repository.find_items_by_invoice_items(id)
  end

  def merchant
    repository.find_by_merchant(merchant_id)
  end

  def customer
    repository.find_by_customer(customer_id)
  end

  def total
    totals = invoice_items.map do |invoice_item|
      invoice_item.unit_price.to_i * invoice_item.quantity.to_i
    end
    totals.empty? ? 0 : totals.reduce(:+)
  end
end
