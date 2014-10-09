require_relative 'test_helper'

class IntegrationTest < Minitest::Test
  attr_reader :engine

  def setup
    file_path = File.expand_path "../support", __FILE__
    @engine = SalesEngine.new(file_path)
    engine.startup
  end

  def test_merchant_to_items_relationship
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    merchant_items = merchant.items
    assert_equal 5, merchant_items.count
    assert_instance_of Item, merchant_items.first
  end

  def method_name

  end

end
