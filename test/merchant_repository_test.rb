require_relative 'test_helper'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :repository,
              :merchants,
              :merchant1,
              :merchant2,
              :merchant3,
              :expected_find_by_all_values,
              :expected_find_by_values,
              :search_terms,
              :engine

  def setup
    merchant_setup

    @engine     = Minitest::Mock.new
    @repository = MerchantRepository.new(engine, merchants)

    @search_terms = {
      id: "1",
      name: "Acme Corp",
      created_at: "2012-03-27 14:53:59 UTC",
      updated_at: "2012-03-27 14:53:59 UTC"
      }

    @expected_find_by_all_values = {
      id: [merchant1],
      name: [merchant2],
      created_at: [merchant1, merchant3],
      updated_at: [merchant1, merchant3]
      }

    @expected_find_by_values = {
      id: merchant1,
      name: merchant2,
      created_at: merchant1,
      updated_at: merchant1
      }
  end

  def merchant_setup
    merchant1_data = { id: "1",
                       name: "Jeff's cookie shop",
                       created_at: "2012-03-27 14:53:59 UTC",
                       updated_at: "2012-03-27 14:53:59 UTC" }

    merchant2_data = { id: "2",
                       name: "Acme Corp",
                       created_at: "2012-03-28 14:53:59 UTC",
                       updated_at: "2012-03-28 14:53:59 UTC" }

    merchant3_data = { id: "3",
                       name: "Turing School",
                       created_at: "2012-03-27 14:53:59 UTC",
                       updated_at: "2012-03-27 14:53:59 UTC" }

    @merchant1 = Merchant.new(repository, merchant1_data)
    @merchant2 = Merchant.new(repository, merchant2_data)
    @merchant3 = Merchant.new(repository, merchant3_data)

    @merchants = [merchant1, merchant2, merchant3 ]
  end

  def test_it_is_empty_when_new
    other_repository = MerchantRepository.new(engine)
    assert_empty(other_repository.all)
  end

  def test_find_by_can_return_empty
    assert_nil repository.find_by_name("Jeff")
  end

  def test_find_by_all_can_return_empty
    assert_equal [], repository.find_all_by_name("Jeff")
  end

  def test_it_can_return_all_merchants
    assert_equal merchants, repository.all
  end

  def test_it_has_a_random_method_which_returns_an_merchant
    assert_instance_of(Merchant, repository.random)
  end

  def test_it_has_a_sales_engine
    assert repository.engine
  end

  def test_it_delegates_items_to_sales_engine
    engine.expect(:find_items_from_merchant, [], ["1"])
    repository.find_items_from("1")
    engine.verify
  end

  def test_it_delegates_invoices_to_sales_engine
    engine.expect(:find_invoices_from_merchant, [], [merchant1.id])
    repository.find_invoices_from(merchant1.id)
    engine.verify
  end

  def test_it_can_find_by_any_attribute
    [:id, :name, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_values[attribute], repository.send("find_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_all_by_any_attribute
    [:id, :name, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_all_values[attribute], repository.send("find_all_by_#{attribute}", search_terms[attribute])
    end
  end
end
