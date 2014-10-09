require 'csv'
require_relative 'transaction'

class TransactionParser
  attr_reader :transactions

  def initialize(repository, filepath)
    transaction_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_transaction_objects(repository, transaction_data)
  end

  def create_transaction_objects(repository, transaction_data)
    @transactions = transaction_data.collect do |transaction_data|
      Transaction.new(repository, transaction_data)
    end
  end
end
