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
    @first_name  = data[:first_name]
    @last_name   = data[:last_name]
    @created_at  = data[:created_at]
    @updated_at  = data[:updated_at]
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
