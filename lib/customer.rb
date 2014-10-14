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
    @transactions ||= invoices.collect { |invoice| invoice.transactions }.flatten
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
end
