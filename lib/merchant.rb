class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(data={})
    @id          = data[:id]
    @name        = data[:name].to_s.downcase
    @created_at  = data[:created_at].to_s.downcase
    @updated_at  = data[:updated_at].to_s.downcase
  end

  def attributes
    [:id,
     :name,
     :created_at,
     :updated_at]
  end
end
