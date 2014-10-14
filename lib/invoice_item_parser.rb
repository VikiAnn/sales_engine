require 'csv'
require_relative 'invoice_item'

class InvoiceItemParser
  attr_reader :invoice_items

  def initialize(repository, filepath)
    data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_invoice_item_objects(repository, data)
  end

  def create_invoice_item_objects(repository, invoice_item_data)
    @invoice_items = invoice_item_data.collect do |invoice_item_data|
      invoice_item_data[:id]         = invoice_item_data[:id].to_i
      invoice_item_data[:item_id]    = invoice_item_data[:item_id].to_i
      invoice_item_data[:quantity]   = invoice_item_data[:quantity].to_i
      invoice_item_data[:unit_price] = invoice_item_data[:unit_price].to_i

      InvoiceItem.new(repository, invoice_item_data)
    end
  end
end
