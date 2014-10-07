class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at

  def initialize(data={})
    @id          = data[:id]
    @customer_id = data[:customer_id]
    @merchant_id = data[:merchant_id]
    @status      = data[:status]
    @created_at  = data[:created_at].to_s.downcase
    @updated_at  = data[:updated_at].to_s.downcase
  end

  def attributes
    [:id,
     :customer_id,
     :merchant_id,
     :status,
     :created_at,
     :updated_at]
  end
end
