require_relative 'test_helper'

class CustomerTest < Minitest::Test
  attr_reader :customer

  def setup
    data = { id: "1",
             first_name: "Billy",
             last_name: "Joe",
             created_at: "2012-03-27 14:53:59 UTC",
             updated_at: "2012-03-27 14:53:59 UTC" }

    @customer = Customer.new(data)
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
end
