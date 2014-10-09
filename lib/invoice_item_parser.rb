require 'csv'
require_relative 'invoice_item'

class InvoiceItemParser
  def initialize(repository, filepath)
    invoice_item_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_invoice_item_objects(repository, invoice_item_data)
  end

  def create_invoice_item_objects(repository, invoice_item_data)
    invoice_item_data.collect do |invoice_item_data|
      InvoiceItem.new(repository, invoice_item_data)
    end
  end
end
