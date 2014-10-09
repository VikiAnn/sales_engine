require_relative 'test_helper'

class ItemRepositoryTest < Minitest::Test
  attr_reader :repository,
              :items,
              :item1,
              :item2,
              :item3,
              :expected_find_by_all_values,
              :expected_find_by_values,
              :search_terms,
              :engine

  def setup
    item_setup

    @engine     = Minitest::Mock.new
    @repository = ItemRepository.new(engine, items)

    @search_terms = {
      id: "1",
      name: "soap",
      description: "minty fresh",
      price: "300",
      merchant_id: "1",
      created_at: "2012-03-27 14:53:59 utc",
      updated_at: "2012-03-27 14:53:59 utc"
      }

    @expected_find_by_all_values = {
      id: [item1],
      name: [item1],
      description: [item1, item3],
      price: [item2, item3],
      merchant_id: [item1, item2],
      created_at: [item1, item3],
      updated_at: [item1, item3]
      }

    @expected_find_by_values = {
      id: item1,
      name: item1,
      description: item1,
      price: item2,
      merchant_id: item1,
      created_at: item1,
      updated_at: item1
      }
  end

  def item_setup
    item1_data = { id: "1",
             name: "soap",
             description: "minty fresh",
             price: "150",
             merchant_id: "1",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc" }
    item2_data = { id: "2",
             name: "Toothpaste",
             description: "Not actually minty",
             price: "300",
             merchant_id: "1",
             created_at: "2012-03-28 14:53:59 utc",
             updated_at: "2012-03-28 14:53:59 utc" }
    item3_data = { id: "3",
             name: "Toothpaste",
             description: "minty fresh",
             price: "300",
             merchant_id: "2",
             created_at: "2012-03-27 14:53:59 utc",
             updated_at: "2012-03-27 14:53:59 utc" }

    @item1 = Item.new(repository, item1_data)
    @item2 = Item.new(repository, item2_data)
    @item3 = Item.new(repository, item3_data)

    @items = [item1, item2, item3 ]
  end

  def test_it_has_an_engine
    assert repository.engine
  end

  def test_it_is_empty_when_new
    other_repository = ItemRepository.new(engine)
    assert_empty(other_repository.all)
  end

  def test_find_by_can_return_empty
    assert_nil repository.find_by_price("50")
  end

  def test_find_by_all_can_return_empty
    assert_equal [], repository.find_all_by_price("50")
  end

  def test_it_can_return_all_items
    assert_equal items, repository.all
  end

  def test_it_has_a_random_method_which_returns_an_item
    assert_instance_of(Item, repository.random)
  end

  def test_it_can_find_by_any_attribute
    [:id, :name, :description, :price, :merchant_id, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_values[attribute], repository.send("find_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_all_by_any_attribute
    [:id, :name, :description, :price, :merchant_id, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_all_values[attribute], repository.send("find_all_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_delegates_find_invoice_items_to_engine
    engine.expect(:find_invoice_items_by_item_id, [], [item1.id])
    repository.find_invoice_items(item1.id)
    engine.verify
  end

  def test_it_delegates_find_merchant_to_engine
    engine.expect(:find_by_merchant, [], [item1.merchant_id])
    repository.find_merchant(item1.merchant_id)
    engine.verify
  end
end
