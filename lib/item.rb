class Item
  attr_reader :id,
              :name,
              :description,
              :price,
              :merchant_id,
              :created_at,
              :updated_at,
              :repository

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @name        = data[:name]
    @description = data[:description]
    @price       = data[:price]
    @merchant_id = data[:merchant_id]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
  end

  def attributes
    [:id,
     :name,
     :description,
     :price,
     :merchant_id,
     :created_at,
     :updated_at]
  end

  def invoice_items
    repository.find_invoice_items(id)
  end

  def merchant
    repository.find_merchant(merchant_id)
  end
end
