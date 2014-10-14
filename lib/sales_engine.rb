require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'item_repository'
require_relative 'invoice_item_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'

require_relative 'merchant_parser'
require_relative 'invoice_parser'
require_relative 'item_parser'
require_relative 'invoice_item_parser'
require_relative 'customer_parser'
require_relative 'transaction_parser'

class SalesEngine
  attr_reader :filepath,
              :merchant_repository,
              :invoice_repository,
              :item_repository,
              :invoice_item_repository,
              :customer_repository,
              :transaction_repository

  def initialize(filepath="../data")
    @filepath = filepath
    @merchant_repository     = MerchantRepository.new(self)
    @invoice_repository      = InvoiceRepository.new(self)
    @item_repository         = ItemRepository.new(self)
    @invoice_item_repository = InvoiceItemRepository.new(self)
    @customer_repository     = CustomerRepository.new(self)
    @transaction_repository  = TransactionRepository.new(self)
  end

  def startup
    merchant_repository.load(filepath)
    invoice_repository.load(filepath)
    item_repository.load(filepath)
    invoice_item_repository.load(filepath)
    customer_repository.load(filepath)
    transaction_repository.load(filepath)
  end

  def find_items_from_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_from_merchant(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_all_transactions_by_invoice_id(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_all_invoice_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_all_items_by_invoice_id(id)
    invoice_item_ids = find_all_invoice_items_by_invoice_id(id)
    item_ids = invoice_item_ids.collect {|invoice_item| invoice_item.item_id }
    item_ids.collect {|item_id| item_repository.find_by_id(item_id) }
  end

  def find_by_customer(id)
    customer_repository.find_by_id(id)
  end

  def find_by_merchant(id)
    merchant_repository.find_by_id(id)
  end

  def find_invoice_by_invoice_id(invoice_id)
    invoice_repository.find_by_id(invoice_id)
  end

  def find_item_by_item_id(item_id)
    item_repository.find_by_id(item_id)
  end

  def find_invoice_items_by_item_id(item_id)
    invoice_item_repository.find_all_by_item_id(item_id)
  end

  def find_all_invoices_by_customer_id(customer_id)
    invoice_repository.find_all_by_customer_id(customer_id)
  end

  def create_invoice_items(invoice_id, items)
    invoice_item_repository.create_invoice_items(invoice_id, items)
  end

  def create_transaction(invoice_id, credit_card_number, credit_card_expiration, result)
    transaction_repository.create_transaction(invoice_id, credit_card_number, credit_card_expiration, result)
  end
end
