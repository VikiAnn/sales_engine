require 'csv'
require_relative 'invoice'

class InvoiceParser
  attr_reader :invoices

  def initialize(repository, filepath)
    data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_invoice_objects(repository, data)
  end

  def create_invoice_objects(repository, invoice_data)
    @invoices = invoice_data.collect do |invoice_data|
      invoice_data[:id] = invoice_data[:id].to_i
      invoice_data[:customer_id] = invoice_data[:customer_id].to_i
      Invoice.new(repository, invoice_data)
    end
  end
end
