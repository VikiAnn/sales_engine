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

  def invoice_dates
    invoices.collect do |invoice|
      Date.parse(invoice.created_at)
    end
  end

  def customers_with_pending_invoices
    unpaid_invoices = invoices.reject { |invoice| invoice.paid? }
    unpaid_invoices.map { |invoice| invoice.customer }
  end

  def favorite_customer
    grouped_customers = paying_customers.group_by{ |customer| customer }
    grouped_customers.max_by do |customer, customer_visits|
      customer_visits.count
    end.first
  end

  def paying_customers
    paid_invoices.map { |invoice| invoice.customer }
  end

  def paid_invoices
    @paid_invoices ||= invoices.select { |invoice| invoice.paid? }
  end

  def revenue(date=nil)
    if date
      if date.is_a?(Date)
        total = total_from_daily(date)
      else
        total = total_from_range(date)
      end
    else
      total = total_paid
    end
    BigDecimal.new(total) / 100
  end

  def total_from_range(dates)
    revenues = dates.to_a.map { |date| total_from_daily(date) }
    revenues.inject(0) { |sum, daily_rev| sum + daily_rev }
  end

  def total_from_daily(date)
    daily_invoices(date).reduce(0) { |total, invoice| total + invoice.total }
  end

  def total_paid
    paid_invoices.reduce(0) { |total, invoice| total + invoice.total }
  end

  def daily_invoices(date)
    paid_invoices.select do |invoice|
      Time.parse(invoice.created_at).to_date == date
    end
  end

  def total_items_sold
    items.reduce(0) { |total, item| total + item.total_sold }
  end
end
