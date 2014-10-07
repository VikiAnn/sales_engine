require_relative 'find'

class CustomerRepository
  include Find

  attr_reader :customers
  def initialize(customers = [])
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

end
