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
    assert_equal 1, customer.id
  end

  def test_invoice_to_merchant_relationship
    invoice = engine.invoice_repository.find_by_id("1")
    merchant = invoice.merchant
    assert_instance_of Merchant, merchant
    assert_equal 26, merchant.id
  end

  def test_invoice_item_to_invoice_relationship
    invoice_item = engine.invoice_item_repository.find_by_id("1")
    invoice = invoice_item.invoice
    assert_instance_of Invoice, invoice
    assert_equal 1, invoice.id
  end

  def test_invoice_item_to_item_relationship
    invoice_item = engine.invoice_item_repository.find_by_id("1")
    item = invoice_item.item
    assert_instance_of Item, item
    assert_equal 539, item.id
  end

  def test_item_to_invoice_items_relationship
    item = engine.item_repository.find_by_id("2")
    invoice_items = item.invoice_items
    assert_instance_of InvoiceItem, invoice_items.first
    assert_equal 2, invoice_items.first.id
  end

  def test_item_to_merchant_id_relationship
    item = engine.item_repository.find_by_id("2")
    merchant = item.merchant
    assert_instance_of Merchant, merchant
    assert_equal 1, merchant.id
  end

  def test_transaction_to_invoice_relationship
    transaction = engine.transaction_repository.find_by_id("1")
    invoice = transaction.invoice
    assert_instance_of Invoice, invoice
    assert_equal 1, invoice.id
  end

  def test_customer_to_invoices_relationship
    customer = engine.customer_repository.find_by_id("1")
    invoices = customer.invoices
    assert_equal 7, invoices.count
    assert_instance_of Invoice, invoices.first
    assert_equal 1, invoices.first.id
  end
end
