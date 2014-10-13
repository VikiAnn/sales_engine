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
    assert_equal 3, merchant_invoices.count
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
    assert_equal 4, invoices.count
    assert_instance_of Invoice, invoices.first
    assert_equal 1, invoices.first.id
  end

  def test_merchant_total_revenue
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    assert_equal BigDecimal.new(560568)/100, merchant.revenue
  end

  def test_business_intelligence_for_merchant_repository_most_revenue_x
    merchants = engine.merchant_repository
    top = merchants.most_revenue(2)
    assert_equal 2, top.count
    assert_equal "Williamson Group", top.first.name
  end

  def test_merchant_total_items_sold
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    assert_equal 58, merchant.total_items_sold
  end

  def test_business_intelligence_for_merchant_repository_most_items_x
    merchants = engine.merchant_repository
    top = merchants.most_items(2)
    assert_equal 2, top.count
    assert_equal "Schroeder-Jerde", top.first.name
  end

  def test_merchant_total_revenue_by_date
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    assert_equal BigDecimal.new(553980)/100, merchant.revenue(Date.new(2012, 3, 8))
    assert_equal BigDecimal.new(6588)/100, merchant.revenue(Date.new(2012, 3, 7))
  end

  def test_business_intelligence_for_merchant_repository_revenue_date
    assert_equal BigDecimal.new(553980)/100, engine.merchant_repository.revenue(Date.new(2012, 3, 8))
    assert_equal BigDecimal.new(13176)/100, engine.merchant_repository.revenue(Date.new(2012, 3, 7))
  end

  def test_BI_for_merchant_favorite_customer
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    assert_equal "Joey", merchant.favorite_customer.first_name
  end

  def test_BI_for_merchant_customers_with_pending_invoices
    merchant = engine.merchant_repository.find_by_name("Schroeder-Jerde")
    unpaid_customers = merchant.customers_with_pending_invoices
    assert_equal 2, unpaid_customers.first.id
  end

  def test_item_can_calculate_total_revenue
    items = engine.item_repository
    item = items.find_by_id(529)
    assert_equal 1661940, item.total_revenue
  end

  def test_BI_can_find_items_with_most_revenue
    items = engine.item_repository
    item1 = items.find_by_id(529)
    item2 = items.find_by_id(523)
    assert_equal [item1, item2], items.most_revenue(2)
  end

  def test_item_can_calculate_the_number_of_times_it_has_been_sold
    items = engine.item_repository
    item1 = items.find_by_id(529)
    assert_equal 21, item1.total_sold
  end

  def test_BI_can_find_most_items_sold_from_item_repository
    items = engine.item_repository
    item1 = items.find_by_id(529)
    item2 = items.find_by_id(535)
    assert_equal [item1, item2], items.most_items(2)
  end

  def test_BI_item_can_find_its_best_sales_day
    items = engine.item_repository
    item1 = items.find_by_id(529)
    assert_equal Date.parse("2012-03-25 14:54:09 UTC"), item1.best_day
  end

  def test_BI_customer_can_find_all_its_transactions
    joey = engine.customer_repository.find_by_id(1)

    assert_equal 6, joey.transactions.count
    assert_instance_of Transaction, joey.transactions.first
  end

  def test_BI_for_customer_favorite_merchant
    customer = engine.customer_repository.find_by_first_name("Joey")
    assert_equal "Schroeder-Jerde", customer.favorite_merchant.name
  end
end
