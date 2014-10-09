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
              :merchants,     :merchant_repository,
              :invoices,      :invoice_repository,
              :items,         :item_repository,
              :invoice_items, :invoice_item_repository,
              :customers,     :customer_repository,
              :transactions,  :transaction_repository

  def initialize(filepath="../data")
    @filepath = filepath
    @merchant_repository      = MerchantRepository.new(self)
    @invoice_repository       = InvoiceRepository.new(self)
    @item_repository          = ItemRepository.new(self)
    @invoice_item_repository  = InvoiceItemRepository.new(self)
    @customer_repository      = CustomerRepository.new(self)
    @transaction_repository   = TransactionRepository.new(self)

    import_data
  end

  def startup
    @merchant_repository      = MerchantRepository.new(self, merchants)
    @invoice_repository       = InvoiceRepository.new(self, invoices)
    @item_repository          = ItemRepository.new(self, items)
    @invoice_item_repository  = InvoiceItemRepository.new(self, invoice_items)
    @customer_repository      = CustomerRepository.new(self, customers)
    @transaction_repository   = TransactionRepository.new(self, transactions)
  end

  def import_data
    @merchants     = MerchantParser.new(merchant_repository, "#{filepath}/merchants.csv").merchants
    @invoices      = InvoiceParser.new(invoice_repository, "#{filepath}/invoices.csv").invoices
    @items         = ItemParser.new(item_repository, "#{filepath}/items.csv").items
    @invoice_items = InvoiceItemParser.new(invoice_item_repository, "#{filepath}/invoice_items.csv").invoice_items
    @customers     = CustomerParser.new(customer_repository, "#{filepath}/customers.csv").customers
    @transactions  = TransactionParser.new(transaction_repository, "#{filepath}/transactions.csv").transactions
  end

  def find_items_from_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end

end
