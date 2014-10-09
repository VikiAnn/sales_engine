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

  def attributes
    [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at]
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
end
