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
    @total_revenue ||= items_sold.reduce(0) do |sum, invoice_item|
      sum + invoice_item.revenue
    end
  end

  def invoice_items
    @invoice_items ||= repository.find_invoice_items(id)
  end

  def merchant
    @merchant ||= repository.find_merchant(merchant_id)
  end

  def invoice_items_by_date
    invoice_items.group_by {|invoice_item| invoice_item.invoice.created_at }
  end

  def best_day
    dates_by_quantity = Hash.new
    invoice_items_by_date.each do |date, invoice_items|
      dates_by_quantity[date] = invoice_items.reduce(0) do |sum, ii|
        sum + ii.quantity
      end
    end
    best_day = dates_by_quantity.max_by { |date, quantity| quantity }
    Date.parse(best_day[0])
  end

  def total_sold
    items_sold.reduce(0) do |total, invoice_item|
      total + invoice_item.quantity
    end
  end

  def items_sold
    @items_sold ||= invoice_items.select do |invoice_item|
      invoice_item.invoice.paid?
    end
  end
end
