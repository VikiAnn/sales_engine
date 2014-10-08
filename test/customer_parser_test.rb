require_relative 'test_helper'

class CustomerParserTest < Minitest::Test
  attr_reader :repository, :customer_parser

  def setup
    @repository = Minitest::Mock.new
    file_pattern = File.expand_path "../support/customers.csv", __FILE__
    @customer_parser = CustomerParser.new(repository, file_pattern)
  end

  def test_customer_parser_exists
    assert customer_parser
  end

  def test_it_returns_correct_number_of_customers
    assert_equal 5, customer_parser.customers.count
  end

  def test_customers_are_valid_customer_objects
    assert_instance_of(Customer, customer_parser.customers.first)
  end
end
