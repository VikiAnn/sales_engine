require_relative 'find'

class TransactionRepository
  include Find

  attr_reader :transactions
  def initialize(transactions = [])
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
end
