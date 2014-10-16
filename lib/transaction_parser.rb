require 'csv'
require_relative 'transaction'

class TransactionParser
  attr_reader :transactions

  def initialize(repository, filepath)
    @filepath = filepath
    create_transaction_objects(repository)
  end

  def create_transaction_objects(repository)
    @transactions = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :numeric }

    CSV.foreach(@filepath, csv_options) do |row|
      @transactions << Transaction.new(repository, row)
    end
  end
end
