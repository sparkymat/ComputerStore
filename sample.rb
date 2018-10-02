require 'bundler'
Bundler.require

Dir['./app/*.rb'].each do |f|
  require f
end

rules = {
  'atv' => PricingRule.new(
    rule_type:     :x_for_y,
    trigger_value: 3,
    deal_value:    2,
    deal_item:     nil
  ),
  'ipd' => PricingRule.new(
    rule_type:     :bulk_discount,
    trigger_value: 4,
    deal_value:    499_99,
    deal_item:     nil
  ),
  'mbp' => PricingRule.new(
    rule_type:     :free_items,
    trigger_value: 1,
    deal_value:    1,
    deal_item:     'vga'
  ),
}

item1 = Item.new('atv')
item2 = Item.new('atv')
item3 = Item.new('atv')
item4 = Item.new('mbp')
item5 = Item.new('ipd')
item6 = Item.new('ipd')
item7 = Item.new('ipd')
item8 = Item.new('ipd')

cart = ShoppingCart.new(rules)
cart.scan(item1)
cart.scan(item2)
cart.scan(item3)
cart.scan(item4)
cart.scan(item5)
cart.scan(item6)
cart.scan(item7)
cart.scan(item8)

puts 'Items:'
ap cart.items

puts 'Total (cents)'
ap cart.total_cents
