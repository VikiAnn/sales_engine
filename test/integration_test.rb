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

  def test_BI_extension_for_merchant_total_revenue_by_range_of_dates
    date1 = Date.parse("2012-03-07")
    date2 = Date.parse("2012-03-25")
    revenue = engine.merchant_repository.revenue(date1..date2)
    assert_equal BigDecimal("22585.43"), revenue
  end

  def test_BI_extension_for_merchant_find_dates_by_revenue
      dates_by_revenue = engine.merchant_repository.dates_by_revenue
      assert_instance_of Date, dates_by_revenue[0]
      assert_equal Date.parse("2012-03-25"), dates_by_revenue[0]
      assert_equal Date.parse("2012-03-12"), dates_by_revenue[3]
      refute_includes(dates_by_revenue, Date.parse("2014-03-25"))
  end

  def test_BI_extension_for_merchant_find_top_x_dates_by_revenue
    dates_by_revenue = engine.merchant_repository.dates_by_revenue(3)
    assert_equal Date.parse("2012-03-25"), dates_by_revenue[0]
    refute_includes(dates_by_revenue, Date.parse("2012-03-12"))
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

  def test_BI_extension_customer_repository_most_items
    customer = engine.customer_repository.find_by_first_name("Joey")
    assert_equal customer, engine.customer_repository.most_items
  end

  def test_BI_extension_most_revenue
    customer = engine.customer_repository.find_by_first_name("Joey")
    assert_equal customer, engine.customer_repository.most_revenue
  end

  def test_BI_extension_customer_days_since_activity
    customer = engine.customer_repository.find_by_first_name("Joey")
    Timecop.freeze(Time.local(2014, 10, 16)) do
      assert_equal -933, customer.days_since_activity
    end
  end

  def test_BI_extension_customer_pending_invoices
    customer = engine.customer_repository.find_by_id(2)
    assert_equal 2, customer.pending_invoices.count
  end

  def test_BI_for_creating_an_invoice
    customer = engine.customer_repository.find_by_id(1)
    merchant = engine.merchant_repository.find_by_id(1)
    item1 = engine.item_repository.find_by_id(1)
    item2 = engine.item_repository.find_by_id(2)
    item3 = engine.item_repository.find_by_id(3)

    invoice = engine.invoice_repository.create(
                                       customer: customer,
                                       merchant: merchant,
                                       status: "shipped",
                                       items: [item1, item2, item3])

    assert_instance_of Invoice, invoice
    assert_equal 1, invoice.customer_id
    assert_equal 1, invoice.merchant_id
    assert_equal 9, invoice.id
    assert_equal 3, invoice.invoice_items.count
  end

  def test_BI_for_charging_an_invoice
    assert_equal 10, engine.transaction_repository.transactions.count
    invoice = engine.invoice_repository.find_by_id(1)
    invoice_id = invoice.id
    invoice.charge(credit_card_number: "4444333322221111",
                   credit_card_expiration_date: "10/13",
                   result: "success")

    assert invoice.paid?
    assert_equal 11, engine.transaction_repository.transactions.count
  end

  def test_BI_extension_invoice_repository_pending
    assert_equal 2, engine.invoice_repository.pending.count
    refute engine.invoice_repository.pending.first.paid?
  end

  def test_BI_extension_invoice_repository_average_revenue
    assert_equal BigDecimal.new("3764.24"), engine.invoice_repository.average_revenue
  end

  def test_BI_extension_invoice_repository_average_revenue_with_date
    date = Date.parse("2012-03-08")
    assert_equal BigDecimal.new("5539.80"), engine.invoice_repository.average_revenue(date)
  end

  def test_BI_extension_invoice_repository_average_items
    assert_equal BigDecimal.new("10.17"), engine.invoice_repository.average_items
  end

  def test_BI_extension_invoice_repository_average_items_with_date
    date = Date.parse("2012-03-08")
    assert_equal BigDecimal.new("7"), engine.invoice_repository.average_items(date)
  end
end
