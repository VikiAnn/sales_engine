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
    @items ||= repository.find_items_from(id)
  end

  def invoices
    @invoices ||= repository.find_invoices_from(id)
  end

  def customers_with_pending_invoices
    invoices.reject { |invoice| invoice.paid? }.map { |invoice| invoice.customer }
  end

  def favorite_customer
    paying_customers.group_by{ |customer| customer }.max_by{ |k,v| v.count }.first
  end

  def paying_customers
    paid_invoices.map { |invoice| invoice.customer }
  end

  def paid_invoices
    @paid_invoices ||= invoices.select { |invoice| invoice.paid? }
  end

  def revenue(date=nil)
    date ? total = total_from_daily(date) : total = total_paid
    BigDecimal.new(total) / 100
  end

  def total_from_daily(date)
    daily_invoices(date).reduce(0) { |total, invoice| total + invoice.total }
  end

  def total_paid
    paid_invoices.reduce(0) { |total, invoice| total + invoice.total }
  end

  def daily_invoices(date)
    paid_invoices.select { |invoice| Time.parse(invoice.created_at).to_date == date }
  end

  def total_items_sold
    items.reduce(0) { |total, item| total + item.total_sold }
  end
end
