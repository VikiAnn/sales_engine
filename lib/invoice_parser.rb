require 'csv'
require_relative 'invoice'

class InvoiceParser
  attr_reader :invoices

  def initialize(repository, filepath)
    @filepath = filepath
    create_invoice_objects(repository)
  end

  def create_invoice_objects(repository)
    @invoices = []
    csv_options = { headers: true,
                    header_converters: :symbol,
                    converters: :numeric }

    CSV.foreach(@filepath, csv_options) do |row|
      @invoices << Invoice.new(repository, row)
    end
  end
end
