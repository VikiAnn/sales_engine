require_relative 'test_helper'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :repository,
              :invoices,
              :invoice1,
              :invoice2,
              :invoice3,
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
      created_at:  "2012-03-27 14:53:59 UTC",
      updated_at:  "2012-03-27 14:53:59 UTC" }

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
             created_at:  "2012-03-27 14:53:59 UTC",
             updated_at:  "2012-03-27 14:53:59 UTC" }

    invoice2_data = { id: "2",
             customer_id: "1",
             merchant_id: "26",
             status:      "delayed",
             created_at:  "2012-03-28 14:53:59 UTC",
             updated_at:  "2012-03-28 14:53:59 UTC" }

    invoice3_data = { id: "3",
             customer_id: "1",
             merchant_id: "28",
             status:      "shipped",
             created_at:  "2012-03-27 14:53:59 UTC",
             updated_at:  "2012-03-27 14:53:59 UTC" }

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
    repository.find_transaction(invoice1.id)
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
end
