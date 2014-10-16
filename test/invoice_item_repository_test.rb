require_relative 'test_helper'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :repository,
              :invoice_items,
              :invoice_item1,
              :invoice_item2,
              :invoice_item3,
              :expected_find_by_all_values,
              :expected_find_by_values,
              :search_terms,
              :engine

  def setup
    invoice_item_setup

    @engine     = Minitest::Mock.new
    @repository = InvoiceItemRepository.new(engine, invoice_items)

    @search_terms = {
      id: "1",
      item_id: "528",
      invoice_id: "1",
      quantity: "8",
      unit_price: "13635",
      created_at: "2012-03-27 14:53:59 utc",
      updated_at: "2012-03-27 14:53:59 utc"
      }

    @expected_find_by_all_values = {
      id: [invoice_item1],
      item_id: [invoice_item2],
      invoice_id: invoice_items,
      quantity: [invoice_item3],
      unit_price: [invoice_item1, invoice_item2],
      created_at: [invoice_item2, invoice_item3],
      updated_at: [invoice_item2, invoice_item3]
      }

    @expected_find_by_values = {
      id: invoice_item1,
      item_id: invoice_item2,
      invoice_id: invoice_item1,
      quantity: invoice_item3,
      unit_price: invoice_item1,
      created_at: invoice_item2,
      updated_at: invoice_item2
      }
  end

  def invoice_item_setup
    invoice_item1_data = { id: "1",
             item_id: "539",
             invoice_id: "1",
             quantity: "5",
             unit_price: "13635",
             created_at: "2012-03-28 14:53:59 utc",
             updated_at: "2012-03-28 14:53:59 utc"
           }
    invoice_item2_data = { id: "2",
             item_id: "528",
             invoice_id: "1",
             quantity: "9",
             unit_price: "13635",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc"
           }
    invoice_item3_data = { id: "3",
             item_id: "523",
             invoice_id: "1",
             quantity: "8",
             unit_price: "13630",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc"
           }

    @invoice_item1 = InvoiceItem.new(repository, invoice_item1_data)
    @invoice_item2 = InvoiceItem.new(repository, invoice_item2_data)
    @invoice_item3 = InvoiceItem.new(repository, invoice_item3_data)

    @invoice_items = [invoice_item1, invoice_item2, invoice_item3 ]
  end

  def test_it_is_empty_when_new
    other_repository = InvoiceItemRepository.new(engine)
    assert_empty(other_repository.all)
  end

  def test_it_has_an_engine
    assert repository.engine
  end

  def test_find_by_can_return_empty
    assert_nil repository.find_by_unit_price("50")
  end

  def test_find_by_all_can_return_empty
    assert_equal [], repository.find_all_by_unit_price("50")
  end

  def test_it_can_return_all_invoice_items
    assert_equal invoice_items, repository.all
  end

  def test_it_has_a_random_method_which_returns_an_invoice_item
    assert_instance_of(InvoiceItem, repository.random)
  end

  def test_it_can_find_by_any_attribute
    [:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_values[attribute], repository.send("find_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_all_by_any_attribute
    [:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_all_values[attribute], repository.send("find_all_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_delegates_find_item_to_engine
    engine.expect(:find_item_by_item_id, [], [invoice_item1.item_id])
    repository.find_item(invoice_item1.item_id)
    engine.verify
  end

  def test_it_delegates_find_invoice_to_engine
    engine.expect(:find_invoice_by_invoice_id, [], [invoice_item1.invoice_id])
    repository.find_invoice(invoice_item1.invoice_id)
    engine.verify
  end
  
  def test_inspect_method
    assert_includes(repository.inspect, "3")
  end
end
