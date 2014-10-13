require_relative 'test_helper'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :repository,
              :invoices,
              :invoice1,
              :invoice2,
              :invoice3,
              :invoice4,
              :expected_find_by_all_values,
              :expected_find_by_values,
              :search_terms,
              :engine

  def setup
    invoice_setup
    @engine = Minitest::Mock.new
    @repository = InvoiceRepository.new(engine, invoices)

    @search_terms = {
      id:          "1",
      customer_id: "1",
      merchant_id: "26",
      status:      "shipped",
      created_at:  "2012-03-27 14:53:59 utc",
      updated_at:  "2012-03-27 14:53:59 utc" }

    @expected_find_by_all_values = {
      id:          [invoice1],
      customer_id: [invoice1, invoice2, invoice3],
      merchant_id: [invoice1, invoice2],
      status:      [invoice1, invoice3],
      created_at:  [invoice1, invoice3],
      updated_at:  [invoice1, invoice3] }

    @expected_find_by_values = {
      id:          invoice1,
      customer_id: invoice1,
      merchant_id: invoice1,
      status:      invoice1,
      created_at:  invoice1,
      updated_at:  invoice1 }
  end

  def invoice_setup
    invoice1_data = { id: "1",
             customer_id: "1",
             merchant_id: "26",
             status:      "shipped",
             created_at:  "2012-03-27 14:53:59 utc",
             updated_at:  "2012-03-27 14:53:59 utc" }

    invoice2_data = { id: "2",
             customer_id: "1",
             merchant_id: "26",
             status:      "delayed",
             created_at:  "2012-03-28 14:53:59 utc",
             updated_at:  "2012-03-28 14:53:59 utc" }

    invoice3_data = { id: "3",
             customer_id: "1",
             merchant_id: "28",
             status:      "shipped",
             created_at:  "2012-03-27 14:53:59 utc",
             updated_at:  "2012-03-27 14:53:59 utc" }

    @invoice1 = Invoice.new(repository, invoice1_data)
    @invoice2 = Invoice.new(repository, invoice2_data)
    @invoice3 = Invoice.new(repository, invoice3_data)

    @invoices = [invoice1, invoice2, invoice3 ]
  end

  def test_it_is_empty_when_new
    other_repository = InvoiceRepository.new(engine)
    assert_empty(other_repository.all)
  end

  def test_find_by_can_return_empty
    assert_nil repository.find_by_status("broken")
  end

  def test_find_by_all_can_return_empty
    assert_equal [], repository.find_all_by_status("broken")
  end

  def test_it_can_return_all_invoices
    assert_equal invoices, repository.all
  end

  def test_it_has_a_random_method_which_returns_an_invoice
    assert_instance_of(Invoice, repository.random)
  end

  def test_it_can_find_by_any_attribute
    [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_values[attribute], repository.send("find_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_all_by_any_attribute
    [:id, :customer_id, :merchant_id, :status, :created_at, :updated_at].each do |attribute|
      assert_equal expected_find_by_all_values[attribute], repository.send("find_all_by_#{attribute}", search_terms[attribute])
    end
  end

  def test_it_can_find_by_transaction
    engine.expect(:find_all_transactions_by_invoice_id, [], [invoice1.id])
    repository.find_transactions(invoice1.id)
    engine.verify
  end

  def test_it_can_find_by_invoice_items
    engine.expect(:find_all_invoice_items_by_invoice_id, [], [invoice1.id])
    repository.find_invoice_items(invoice1.id)
    engine.verify
  end

  def test_it_can_find_items_by_invoice
    engine.expect(:find_all_items_by_invoice_id, [], [invoice1.id])
    repository.find_items_by_invoice_items(invoice1.id)
    engine.verify
  end

  def test_it_can_find_the_customer_for_an_invoice
    engine.expect(:find_by_customer, [], [invoice1.customer_id])
    repository.find_by_customer(invoice1.customer_id)
    engine.verify
  end

  def test_it_can_find_the_merchant_for_an_invoice
    engine.expect(:find_by_merchant, [], [invoice1.merchant_id])
    repository.find_by_merchant(invoice1.merchant_id)
    engine.verify
  end

  def test_it_can_create_an_invoice
    customer_data = { id: "1",
                      first_name: "billy",
                      last_name: "joe",
                      created_at: "2012-03-27 14:53:59 utc",
                      updated_at: "2012-03-27 14:53:59 utc" }
    customer_repository = CustomerRepository.new(engine)
    customer = Customer.new(customer_repository, customer_data)

    merchant_data = { id:         "1",
                      name:       "joe bob incorporated",
                      created_at: "2012-03-27 14:53:59 utc",
                      updated_at: "2012-03-27 14:53:59 utc" }
    merchant_repository = MerchantRepository.new(engine)
    merchant = Merchant.new(merchant_repository, merchant_data)

    item1_data = { id: "1",
                   name: "soap",
                   description: "minty fresh",
                   unit_price: "150",
                   merchant_id: "1",
                   created_at: "2012-03-27 14:53:59 utc",
                   updated_at: "2012-03-27 14:53:59 utc" }
    item2_data = { id: "2",
                   name: "Toothpaste",
                   description: "Not actually minty",
                   unit_price: "300",
                   merchant_id: "1",
                   created_at: "2012-03-28 14:53:59 utc",
                   updated_at: "2012-03-28 14:53:59 utc" }
    item3_data = { id: "3",
                   name: "Toothpaste",
                   description: "minty fresh",
                   unit_price: "300",
                   merchant_id: "2",
                   created_at: "2012-03-27 14:53:59 utc",
                   updated_at: "2012-03-27 14:53:59 utc" }

    item_repository = ItemRepository.new(engine)
    item1 = Item.new(item_repository, item1_data)
    item2 = Item.new(item_repository, item2_data)
    item3 = Item.new(item_repository, item3_data)

    engine.expect(:create_invoice_items, [], [4, [item1, item2, item3]])

    invoice = repository.create(customer: customer, merchant: merchant, status: "shipped",
                                items: [item1, item2, item3])
    engine.verify
    assert_instance_of Invoice, invoice
    assert_equal 1, invoice.customer_id
    assert_equal 1, invoice.merchant_id
    assert_equal 4, invoice.id
  end

  def test_it_can_charge_an_invoice
    engine.expect(:create_transaction, [], ["4444333322221111", "10/13", "success"])
    repository.charge(credit_card_number: "4444333322221111",
               credit_card_expiration_date: "10/13", result: "success")
    engine.verify
  end
end
