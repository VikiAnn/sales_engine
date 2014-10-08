class Customer
  attr_reader :repository,
              :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at

  def initialize(repository, data={})
    @repository  = repository
    @id          = data[:id]
    @first_name  = data[:first_name].to_s.downcase
    @last_name   = data[:last_name].to_s.downcase
    @created_at  = data[:created_at].to_s.downcase
    @updated_at  = data[:updated_at].to_s.downcase
  end

  def attributes
    [:id,
     :first_name,
     :last_name,
     :created_at,
     :updated_at]
  end

  def invoices
    repository.find_invoices(id)
  end
end
