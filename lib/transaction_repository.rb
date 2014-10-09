class TransactionRepository
  attr_reader :transactions,
              :engine

  def initialize(engine, transactions = [])
    @engine       = engine
    @transactions = transactions
  end

  [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at].each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      transactions.find { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
    end
  end

  [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at].each do |attribute|
    define_method("find_all_by_#{attribute}") do |attribute_value|
      transactions.select { |object| object.send(attribute).to_s.downcase == attribute_value.to_s.downcase }
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

  def inspect
    "#<#{self.class} #{transactions.size} rows>"
  end
end
