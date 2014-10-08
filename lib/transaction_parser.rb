require 'csv'

class TransactionParser
  attr_reader :transactions

  def initialize(repository, filepath)
    transaction_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_transaction_objects(repository, transaction_data)
  end

  def create_transaction_objects(repository, transaction_data)
    @transactions = transaction_data.collect do |transaction_data|
      transaction_data[:invoice_id]         = transaction_data[:name].to_s.downcase
      transaction_data[:credit_card_number] = transaction_data[:description].to_s.downcase
      transaction_data[:created_at]         = transaction_data[:created_at].to_s.downcase
      transaction_data[:updated_at]         = transaction_data[:updated_at].to_s.downcase
      Transaction.new(repository, transaction_data)
    end
  end
end
