require_relative 'find'

class MerchantRepository
  include Find

  attr_reader :merchants,
              :engine

  def initialize(engine, merchants = [])
    @engine    = engine
    @merchants = merchants
    Find.find_by_generator(merchants)
    Find.find_all_by_generator(merchants)
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def find_items_from(id)
    engine.find_items_from_merchant(id)
  end

end
