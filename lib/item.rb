class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @name        = data[:name]
    @description = data[:description]
    @unit_price  = data[:unit_price]
    @merchant_id = data[:merchant_id]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def total_revenue
    invoice_items.reduce(0) do |sum, invoice_item|
      sum + invoice_item.revenue
    end
  end

  def invoice_items
    repository.find_invoice_items(id)
  end

  def merchant
    repository.find_merchant(merchant_id)
  end

  def best_day
    invoice_items.max_by{|invoice_item| invoice_item.quantity }.created_at
  end

  def total_sold
    invoice_items.reduce(0) {|total, invoice_item| total + invoice_item.quantity }
  end
end
