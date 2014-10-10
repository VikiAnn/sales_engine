require 'date'
class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @name        = data[:name]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def items
    repository.find_items_from(id)
  end

  def invoices
    repository.find_invoices_from(id)
  end

  def customers_with_pending_invoices
    invoices.reject { |invoice| invoice.paid? }.map { |invoice| invoice.customer }
  end

  def favorite_customer
    paid_invoices = invoices.select { |invoice| invoice.paid? }
    paying_customers = paid_invoices.map { |invoice| invoice.customer }
    paying_customers.group_by{ |customer| customer }.max_by{ |k,v| v.count }.first
  end

  def revenue(date="total")
    if date == "total"
      totals = invoices.map { |invoice| invoice.total }
    else
      daily_invoices = invoices.select { |invoice| Time.parse(invoice.created_at).to_date == date }
      totals = daily_invoices.map { |invoice| invoice.total }
    end
    totals.empty? ? 0 : totals.reduce(:+)
  end

  def total_items_sold
    items.reduce(0) { |total, item| total + item.total_sold }
  end
end
