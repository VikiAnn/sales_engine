require_relative 'test_helper'

class ItemTest < Minitest::Test
  attr_reader :item,
              :repository

  def setup
    data = { id: "1",
             name: "soap",
             description: "minty fresh",
             unit_price: "150",
             merchant_id: "1",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc" }

    @repository = Minitest::Mock.new
    @item       = Item.new(repository, data)
  end

  def test_it_has_a_repository
    assert item.repository
  end

  def test_it_has_an_id
    assert_equal "1", item.id
  end

  def test_it_has_a_name
    assert_equal "soap", item.name
  end

  def test_it_has_a_description
    assert_equal "minty fresh", item.description
  end

  def test_it_has_a_unit_price
    assert_equal "150", item.unit_price
  end

  def test_it_has_a_merchant_id
    assert_equal "1", item.merchant_id
  end

  def test_it_has_a_created_at_time
    assert_equal "2012-03-27 14:53:59 utc", item.created_at
  end

  def test_it_has_an_updated_at_time
    assert_equal "2012-03-27 14:53:59 utc", item.updated_at
  end

  def test_it_delegates_find_invoice_items_to_repository
    repository.expect(:find_invoice_items, [], [item.id])
    item.invoice_items
    repository.verify
  end

  def test_it_delegates_find_merchant_to_repository
    repository.expect(:find_merchant, [], [item.merchant_id])
    item.merchant
    repository.verify
  end
end
