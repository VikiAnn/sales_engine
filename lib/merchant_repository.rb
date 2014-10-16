class MerchantRepository
  MERCHANT_ATTRIBUTES = [ :id,
                          :name,
                          :created_at,
                          :updated_at ]

  attr_reader :merchants,
              :engine

  def initialize(engine, merchants = [])
    @engine    = engine
    @merchants = merchants
  end

  def load(filepath)
    @merchants = MerchantParser.new(self, filepath).merchants
  end

  MERCHANT_ATTRIBUTES.each do |attribute|
    define_method("find_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      merchants.find do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end

    define_method("find_all_by_#{attribute}") do |attribute_value|
      attribute_value = attribute_value.to_s.downcase
      merchants.select do |object|
        object.send(attribute).to_s.downcase == attribute_value
      end
    end
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def revenue(date)
    merchants.map{|merchant| merchant.revenue(date)}.reduce(:+)
  end

  def merchants_by_revenue
    merchants.sort_by {|merchant| -merchant.revenue }
  end

  def merchants_by_items_sold
    merchants.sort_by {|merchant| -merchant.total_items_sold }
  end

  def most_revenue(number_of_results)
    merchants_by_revenue[0..number_of_results-1]
  end

  def dates_by_revenue(number=nil)
    number ? sorted_dates[0..number-1] : sorted_dates
  end

  def sorted_dates
    invoice_dates = merchants.collect(&:invoice_dates).flatten!
    dates = invoice_dates.group_by { |date| date }.keys
    dates.sort_by { |date| -revenue(date) }
  end

  def most_items(number_of_results)
    merchants_by_items_sold[0..number_of_results-1]
  end

  def find_items_from(id)
    engine.find_items_from_merchant(id)
  end

  def find_invoices_from(id)
    engine.find_invoices_from_merchant(id)
  end

  def inspect
    "#<#{self.class} #{merchants.size} rows>"
  end
end
