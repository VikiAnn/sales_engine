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

  def revenue
    totals = invoices.map {|invoice| invoice.total}
    totals.empty? ? 0 : totals.reduce(:+)
  end

  def total_items_sold
    totals = items.map { |item| item.invoice_items.count }
    totals.empty? ? 0 : totals.reduce(:+)
  end
end
