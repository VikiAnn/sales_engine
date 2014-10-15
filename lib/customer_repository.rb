class CustomerRepository
  CUSTOMER_ATTRIBUTES = [ :id,
                          :first_name,
                          :last_name,
                          :created_at,
                          :updated_at ]

  attr_reader :engine, :customers

  def initialize(engine, customers = [])
    @engine = engine
    @customers = customers
  end

  def load(filepath)
    @customers = CustomerParser.new(self, filepath).customers
  end

  CUSTOMER_ATTRIBUTES.each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      customers.find do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      customers.select do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end
  end

  def all
    customers
  end

  def random
    customers.sample
  end

  def find_invoices(customer_id)
    engine.find_all_invoices_by_customer_id(customer_id)
  end

  def most_items
    customers.max_by(&:total_items_purchased)
  end

  def most_revenue
    customers.max_by(&:total_revenue)
  end

  def inspect
    "#<#{self.class} #{customers.size} rows>"
  end
end
