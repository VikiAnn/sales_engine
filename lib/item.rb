class Item
  attr_reader :id,
              :name,
              :description,
              :price,
              :merchant_id,
              :created_at,
              :updated_at

  def initialize(data={})
    @id          = data[:id]
    @name        = data[:name].to_s.downcase
    @description = data[:description].to_s.downcase
    @price       = data[:price]
    @merchant_id = data[:merchant_id]
    @created_at  = data[:created_at].to_s.downcase
    @updated_at  = data[:updated_at].to_s.downcase
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
end
