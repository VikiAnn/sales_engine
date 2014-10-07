require_relative 'test_helper'

class TransactionTest < Minitest::Test
  attr_reader :transaction

  def setup
    data = { id: "1",
             invoice_id: "1",
             credit_card_number: "4654405418249632",
             credit_card_expiration_date: "",
             result: "success",
             created_at: "2012-03-27 14:53:59 UTC",
             updated_at: "2012-03-27 14:53:59 UTC" }

    @transaction = Transaction.new(data)
  end

  def test_it_has_an_id
    assert_equal "1", transaction.id
  end

  def test_it_has_an_invoice_id
    assert_equal "1", transaction.invoice_id
  end

  def test_it_has_a_credit_card_number
    assert_equal "4654405418249632", transaction.credit_card_number
  end

  def test_it_has_a_credit_card_expiration_date
    assert_equal "", transaction.credit_card_expiration_date
  end

  def test_it_has_a_result
    assert_equal "success", transaction.result
  end

  def test_it_has_a_created_at_time
    assert_equal "2012-03-27 14:53:59 utc", transaction.created_at
  end

  def test_it_has_an_updated_at_time
    assert_equal "2012-03-27 14:53:59 utc", transaction.updated_at
  end
end
