require_relative 'test_helper'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item,
              :repository

  def setup
    data = { id:         "1",
             item_id:    "539",
             invoice_id: "1",
             quantity:   "5",
             unit_price: "13635",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc" }

    @repository   = Minitest::Mock.new
    @invoice_item = InvoiceItem.new(repository, data)
  end

  # def test_it_can_calculate_revenue
  #   assert
  # end

  def test_it_has_a_repository
    assert invoice_item.repository
  end

  def test_it_has_an_id
    assert_equal "1", invoice_item.id
  end

  def test_it_has_an_item_id
    assert_equal "539", invoice_item.item_id
  end

  def test_it_has_an_invoice_id
    assert_equal "1", invoice_item.invoice_id
  end

  def test_it_has_a_quantity
    assert_equal "5", invoice_item.quantity
  end

  def test_it_has_a_unit_price
    assert_equal "13635", invoice_item.unit_price
  end

  def test_it_has_a_created_at_time
    assert_equal "2012-03-27 14:53:59 utc", invoice_item.created_at
  end

  def test_it_has_an_updated_at_time
    assert_equal "2012-03-27 14:53:59 utc", invoice_item.updated_at
  end

  def test_it_delegates_find_item_to_repository
    repository.expect(:find_item, [], [invoice_item.item_id])
    invoice_item.item
    repository.verify
  end

  def test_it_delegates_find_invoice_to_repository
    repository.expect(:find_invoice, [], [invoice_item.invoice_id])
    invoice_item.invoice
    repository.verify
  end
end
