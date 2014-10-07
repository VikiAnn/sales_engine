require_relative 'test_helper'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :repository,
              :customers,
              :customer1,
              :customer2,
              :customer3,
              :expected_find_by_all_values,
              :expected_find_by_values,
              :search_terms

  def setup
    customer_setup

    @repository = CustomerRepository.new(customers)

    @search_terms = {
      id: "1",
      first_name: "Bob",
      last_name: "Huckenberry",
      created_at: "2012-03-28 14:53:59 UTC",
      updated_at: "2012-03-27 14:53:59 UTC"
      }

    @expected_find_by_all_values = {
      id: [customer1],
      first_name: [customer2],
      last_name: [customer3],
      created_at: [customer1, customer2],
      updated_at: [customer3]
      }

    @expected_find_by_values = {
      id: customer1,
      first_name: customer2,
      last_name: customer3,
      created_at: customer1,
      updated_at: customer3
      }
  end

  def customer_setup
    customer1_data = { id: "1",
                       first_name: "Joe",
                       last_name: "Smith",
                       created_at: "2012-03-28 14:53:59 UTC",
                       updated_at: "2012-03-28 14:53:59 UTC" }

    customer2_data = { id: "2",
                       first_name: "Bob",
                       last_name: "Janeway",
                       created_at: "2012-03-28 14:53:59 UTC",
                       updated_at: "2012-03-28 14:53:59 UTC" }

    customer3_data = { id: "3",
                       first_name: "Jane",
                       last_name: "Huckenberry",
                       created_at: "2012-03-27 14:53:59 UTC",
                       updated_at: "2012-03-27 14:53:59 UTC" }

    @customer1 = Customer.new(customer1_data)
    @customer2 = Customer.new(customer2_data)
    @customer3 = Customer.new(customer3_data)

    @customers = [customer1, customer2, customer3 ]
  end

  def test_it_is_empty_when_new
    other_repository = CustomerRepository.new
    assert_empty(other_repository.all)
  end

  def test_find_by_can_return_empty
    assert_nil repository.find_by_first_name("Jeff")
  end

  def test_find_by_all_can_return_empty
    assert_equal [], repository.find_all_by_first_name("Jeff")
  end

  def test_it_can_return_all_customers
    assert_equal customers, repository.all
  end

  def test_it_has_a_random_method_which_returns_an_customer
    assert_instance_of(Customer, repository.random)
  end

  def test_it_can_find_by_any_attribute
    [:id, :first_name, :last_name, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_values[attribute], repository.send("find_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_all_by_any_attribute
    [:id, :first_name, :last_name, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_all_values[attribute], repository.send("find_all_by_#{attribute}", search_terms[attribute])
    end
  end
end
