require 'csv'
require_relative 'invoice'

class InvoiceParser
  attr_reader :invoices

  def initialize(repository, filepath)
    invoice_data = CSV.readlines filepath, headers: true, header_converters: :symbol
    create_invoice_objects(repository, invoice_data)
  end

  def create_invoice_objects(repository, invoice_data)
    @invoices = invoice_data.collect do |invoice_data|
      invoice_data[:id]          = invoice_data[:id]
      invoice_data[:customer_id] = invoice_data[:customer_id]
      invoice_data[:merchant_id] = invoice_data[:merchant_id]
      invoice_data[:status]      = invoice_data[:status]
      invoice_data[:created_at]  = invoice_data[:created_at].to_s.downcase
      invoice_data[:updated_at]  = invoice_data[:updated_at].to_s.downcase
      Invoice.new(repository, invoice_data)
    end
  end
end
