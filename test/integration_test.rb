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
    assert_equal 9, merchant_items.count
    assert_instance_of Item, merchant_items.first
  end

  def test_merchant_to_invoices_relationship
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    merchant_invoices = merchant.invoices
    assert_equal 2, merchant_invoices.count
    assert_instance_of Invoice, merchant_invoices.first
  end

  def test_invoice_to_transaction_relationship
    invoice = engine.invoice_repository.find_by_id("1")
    transactions = invoice.transactions
    assert_equal 2, transactions.count
    assert_instance_of Transaction, transactions.first
  end

  def test_invoice_to_invoice_items_relationship
    invoice = engine.invoice_repository.find_by_id("1")
    invoice_items = invoice.invoice_items
    assert_equal 7, invoice_items.count
    assert_instance_of InvoiceItem, invoice_items.first
  end

  def test_invoice_to_items_relationship
    invoice = engine.invoice_repository.find_by_id("1")
    items = invoice.items
    assert_equal 7, items.count
    assert_instance_of Item, items.first
  end

  def test_invoice_to_customer_relationship
    invoice = engine.invoice_repository.find_by_id("1")
    customer = invoice.customer
    assert_instance_of Customer, customer
  end

  def test_invoice_to_merchant_relationship
    invoice = engine.invoice_repository.find_by_id("1")
    merchant = invoice.merchant
    assert_instance_of Merchant, merchant
  end
end
