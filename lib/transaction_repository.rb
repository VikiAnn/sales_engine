class TransactionRepository
  attr_reader :transactions,
              :engine

  def initialize(engine, transactions = [])
    @engine       = engine
    @transactions = transactions
  end

  def load(filepath)
    @transactions = TransactionParser.new(self, filepath).transactions
  end

  [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      transactions.find do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      transactions.select do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end
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

  def create_transaction(invoice_id, transaction_data)
    id = transactions.last.id
    data = { id: id,
             invoice_id: invoice_id,
             credit_card_number: transaction_data[:credit_card_number],
             credit_card_expiration_date: transaction_data[:cc_expiration_date],
             result: transaction_data[:result],
             created_at: Time.now,
             updated_at: Time.now }
    add_to_transactions(Transaction.new(self, data))
  end

  def add_to_transactions(transaction)
    transactions << transaction
    transaction
  end

  def inspect
    "#<#{self.class} #{transactions.size} rows>"
  end
end
