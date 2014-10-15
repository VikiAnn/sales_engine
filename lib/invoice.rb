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
    @transactions ||= repository.find_transactions(id)
  end

  def refresh_transactions
    @transactions = repository.find_transactions(id)
  end

  def paid?
    @paid ||= transactions.count do |transaction|
      transaction.result == "success"
    end > 0
  end

  def invoice_items
    @invoice_items ||= repository.find_invoice_items(id)
  end

  def items
    @items ||= repository.find_items_by_invoice_items(id)
  end

  def merchant
    @merchant ||= repository.find_by_merchant(merchant_id)
  end

  def customer
    @customer ||= repository.find_by_customer(customer_id)
  end

  def total
    @total ||= invoice_items.reduce(0) do |total, invoice_item|
      total + (invoice_item.unit_price.to_i * invoice_item.quantity.to_i)
    end
  end

  def charge(params)
    transaction_data = {
      credit_card_number: params[:credit_card_number],
      cc_expiration_date: params[:credit_card_expiration_date],
      result: params[:result] || "success"
    }
    repository.charge(id, transaction_data)
    refresh_transactions
  end
end
