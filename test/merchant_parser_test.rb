require_relative 'test_helper'

class MerchantParserTest < Minitest::Test
  attr_reader :repository, :merchant_parser

  def setup
    @repository = Minitest::Mock.new
    file_pattern = File.expand_path "../support/merchants.csv", __FILE__
    @merchant_parser = MerchantParser.new(repository, file_pattern)
  end

  def test_merchant_parser_exists
    assert merchant_parser
  end

  def test_it_returns_correct_number_of_merchants
    assert_equal 5, merchant_parser.merchants.count
  end

  def test_merchants_are_valid_merchant_objects
    assert_instance_of(Merchant, merchant_parser.merchants.first)
  end
end
