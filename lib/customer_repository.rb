require_relative 'find'

class CustomerRepository
  include Find

  attr_reader :engine, :customers

  def initialize(engine, customers = [])
    @engine = engine
    @customers = customers
    Find.find_by_generator(customers)
    Find.find_all_by_generator(customers)
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
end
