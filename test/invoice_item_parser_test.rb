require_relative 'test_helper'

class InvoiceItemParserTest < Minitest::Test
  attr_reader :repository, :invoice_item_parser

  def setup
    @repository = Minitest::Mock.new
    file_pattern = File.expand_path "../support/invoice_items.csv", __FILE__
    @invoice_item_parser = InvoiceItemParser.new(repository, file_pattern)
  end

  def test_invoice_item_parser_exists
    assert invoice_item_parser
  end

  def test_it_returns_correct_number_of_invoice_items
    assert_equal 9, invoice_item_parser.invoice_items.count
  end

  def test_invoice_items_are_valid_invoice_item_objects
    assert_instance_of(InvoiceItem, invoice_item_parser.invoice_items.first)
  end
end
