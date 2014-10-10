require_relative 'test_helper'

class InvoiceParserTest < Minitest::Test
  attr_reader :repository, :invoice_parser

  def setup
    @repository = Minitest::Mock.new
    file_pattern = File.expand_path "../support/invoices.csv", __FILE__
    @invoice_parser = InvoiceParser.new(repository, file_pattern)
  end

  def test_invoice_parser_exists
    assert invoice_parser
  end

  def test_it_returns_correct_number_of_invoices
    assert_equal 8, invoice_parser.invoices.count
  end

  def test_invoices_are_valid_invoice_objects
    assert_instance_of(Invoice, invoice_parser.invoices.first)
  end
end
