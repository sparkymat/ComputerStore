class ShoppingCart
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
  end

  def scan(item)
    raise 'invalid sku'
  end
end
