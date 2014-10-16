require 'csv'
require_relative 'invoice_item'

class InvoiceItemParser
  attr_reader :invoice_items, :invoice_items_by_invoice_id

  def initialize(repository, filepath)
    @filepath = filepath
    create_invoice_item_objects(repository)
  end

  def create_invoice_item_objects(repository)
    @invoice_items = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :all }
    @invoice_items_by_invoice_id = {}

    CSV.foreach(@filepath, csv_options) do |row|
      add_invoice_item(InvoiceItem.new(repository, row))
    end
  end

  def add_invoice_item(invoice_item)
    @invoice_items << invoice_item
    @invoice_items_by_invoice_id[invoice_item.invoice_id] ||= []
    @invoice_items_by_invoice_id[invoice_item.invoice_id] << invoice_item
  end
end
