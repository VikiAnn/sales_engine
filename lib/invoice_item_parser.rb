require 'csv'
require_relative 'invoice_item'

class InvoiceItemParser
  attr_reader :invoice_items

  def initialize(repository, filepath)
    @filepath = filepath
    create_invoice_item_objects(repository)
  end

  def create_invoice_item_objects(repository)
    @invoice_items = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :numeric }

    CSV.foreach(@filepath, csv_options) do |row|
      @invoice_items << InvoiceItem.new(repository, row)
    end
  end
end
