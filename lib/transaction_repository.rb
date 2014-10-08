require_relative 'find'

class TransactionRepository
  include Find

  attr_reader :transactions,
              :engine

  def initialize(engine, transactions = [])
    @engine       = engine
    @transactions = transactions
    Find.find_by_generator(transactions)
    Find.find_all_by_generator(transactions)
  end

  def all
    transactions
  end

  def random
    transactions.sample
  end

  def find_invoice(invoice_id)
    engine.find_invoice_by_invoice_id(invoice_id)
  end
end
