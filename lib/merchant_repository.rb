require_relative 'find'

class MerchantRepository
  include Find

  attr_reader :merchants
  def initialize(merchants = [])
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

end
