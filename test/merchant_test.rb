require_relative 'test_helper'

class MerchantTest < Minitest::Test
  attr_reader :merchant,
              :repository

  def setup
    data = { id:         "1",
             name:       "Joe Bob Incorporated",
             created_at: "2012-03-27 14:53:59 UTC",
             updated_at: "2012-03-27 14:53:59 UTC" }

    @repository = Minitest::Mock.new
    @merchant  = Merchant.new(repository, data)
  end

  def test_it_has_an_id
    assert_equal "1", merchant.id
  end

  def test_it_has_a_name
    assert_equal "joe bob incorporated", merchant.name
  end

  def test_it_has_a_created_at_time
    assert_equal "2012-03-27 14:53:59 utc", merchant.created_at
  end

  def test_it_has_an_updated_at_time
    assert_equal "2012-03-27 14:53:59 utc", merchant.updated_at
  end

  def test_it_has_a_repository
    assert merchant.repository
  end

  def test_it_delegates_items_to_its_repository
    repository.expect(:find_items_from, [], ["1"])
    merchant.items
    repository.verify
  end

  def test_it_delegates_invoices_to_repository
    repository.expect(:find_invoices_from, [], ["1"])
    merchant.invoices
    repository.verify
  end
end
