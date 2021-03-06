class Customer
  attr_reader :repository,
              :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @first_name  = data[:first_name]
    @last_name   = data[:last_name]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def invoices
    @invoices ||= repository.find_invoices(id)
  end

  def transactions
    @transactions ||= invoices.collect do |invoice|
      invoice.transactions
    end.flatten
  end

  def favorite_merchant
    favorite_merchants.max_by{ |merchant, merchants| merchants.count }.first
  end

  def favorite_merchants
    merchants.group_by{ |merchant| merchant }
  end

  def merchants
    @merchants ||= paid_invoices.map { |invoice| invoice.merchant }
  end

  def paid_invoices
    invoices.select { |invoice| invoice.paid? }
  end

  def days_since_activity
    Date.parse(transactions.last.created_at) - Date.today
  end

  def pending_invoices
    invoices.reject { |invoice| invoice.paid? }
  end

  def total_items_purchased
    paid_invoices.reduce(0) { |total, invoice| total + invoice.total_quantity }
  end

  def total_revenue
    paid_invoices.reduce(0) { |total, invoice| total + invoice.total }
  end
end
