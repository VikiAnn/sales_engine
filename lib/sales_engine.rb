
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
    @merchants     = MerchantParser.new("#{filepath}/merchants.csv")
    @invoices      = InvoiceParser.new("#{filepath}/invoices.csv")
    @items         = ItemParser.new("#{filepath}/items.csv")
    @invoice_items = InvoiceItemParser.new("#{filepath}/invoice_items.csv")
    @customers     = CustomerParser.new("#{filepath}/customers.csv")
    @transactions  = TransactionParser.new("#{filepath}/transactions.csv")
  end

end
