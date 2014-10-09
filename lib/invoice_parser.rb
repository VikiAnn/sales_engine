require 'csv'
require_relative 'invoice'

class InvoiceParser
  def initialize(repository, filepath)
    invoice_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_invoice_objects(repository, invoice_data)
  end

  def create_invoice_objects(repository, invoice_data)
    invoice_data.collect do |invoice_data|
      invoice_data[:customer_id] = invoice_data[:customer_id].to_i
      Invoice.new(repository, invoice_data)
    end
  end
end
