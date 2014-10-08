require_relative 'test_helper'

class ItemParserTest < Minitest::Test
  attr_reader :repository, :item_parser

  def setup
    @repository = Minitest::Mock.new
    file_pattern = File.expand_path "../support/items.csv", __FILE__
    @item_parser = ItemParser.new(repository, file_pattern)
  end

  def test_item_parser_exists
    assert item_parser
  end

  def test_it_returns_correct_number_of_items
    assert_equal 5, item_parser.items.count
  end

  def test_items_are_valid_item_objects
    assert_instance_of(Item, item_parser.items.first)
  end
end
