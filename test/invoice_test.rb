require_relative 'test_helper'

class InvoiceTest < Minitest::Test
  attr_reader :invoice,
              :repository

  def setup
    data = { id:          "1",
             customer_id: "1",
             merchant_id: "26",
             status:      "shipped",
             created_at:  "2012-03-27 14:53:59 UTC",
             updated_at:  "2012-03-27 14:53:59 UTC" }
    @repository = Minitest::Mock.new
    @invoice    = Invoice.new(repository, data)
  end

  def test_it_has_an_id
    assert_equal "1", invoice.id
  end

  def test_it_has_a_customer_id
    assert_equal "1", invoice.customer_id
  end

  def test_it_has_a_merchant_id
    assert_equal "26", invoice.merchant_id
  end

  def test_it_has_a_status
    assert_equal "shipped", invoice.status
  end

  def test_it_has_a_created_at_time
    assert_equal "2012-03-27 14:53:59 utc", invoice.created_at
  end

  def test_it_has_an_updated_at_time
    assert_equal "2012-03-27 14:53:59 utc", invoice.updated_at
  end

  def test_it_has_a_repository
    assert invoice.repository
  end

  def test_it_delegates_merchant_to_its_repository
    repository.expect(:find_by_merchant, [], ["26"])
    invoice.merchant
    repository.verify
  end

  def test_it_delegates_customer_to_its_repository
    repository.expect(:find_by_customer, [], ["1"])
    invoice.customer
    repository.verify
  end
end
