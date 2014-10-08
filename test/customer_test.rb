require_relative 'test_helper'

class CustomerTest < Minitest::Test
  attr_reader :customer, :repository

  def setup
    data = { id: "1",
             first_name: "billy",
             last_name: "joe",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc" }

    @repository = Minitest::Mock.new
    @customer = Customer.new(repository, data)
  end

  def test_it_has_an_id
    assert_equal "1", customer.id
  end

  def test_it_has_a_first_name
    assert_equal "billy", customer.first_name
  end

  def test_it_has_a_last_name
    assert_equal "joe", customer.last_name
  end

  def test_it_has_a_created_at_time
    assert_equal "2012-03-27 14:53:59 utc", customer.created_at
  end

  def test_it_has_an_updated_at_time
    assert_equal "2012-03-27 14:53:59 utc", customer.updated_at
  end

  def test_it_delegates_invoices_to_repository
    repository.expect(:find_invoices, [], [customer.id])
    customer.invoices
    repository.verify
  end
end
