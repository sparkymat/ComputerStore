# frozen_string_literal: true

class ShoppingCart
  attr_reader :items, :total_cents

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @scanned_items = []
    @items = []
    @total_cents = 0
  end

  def scan(item)
    @scanned_items << item

    recalculate
  end

  private

  def recalculate
    @items = []
    @total_cents = 0

    items_by_sku = @scanned_items.group_by{ |item| item.details.sku }

    items_by_sku.each_pair do |sku, items|
      pricing_rule = @pricing_rules[sku]

      if pricing_rule.nil?
        @items += items
        @total_cents += items.map{|it| i.details.price_cents}.inject(:+)
      else
        # Given that the items are grouped by sku, we can get first item to get the price_cents
        rule_result = pricing_rule.apply(sku: sku, price_cents: items.first.details.price_cents, count: items.count)
        @total_cents += rule_result[:total_cents]
        rule_result[:items].each do |result_item|
          if result_item[:sku] == sku
            @items += items # Add back the original set
            (result_item[:count] - items.count).times do
              @items << Item.new(result_item[:sku])
            end
          else
            result_item[:count].times do
              @items << Item.new(result_item[:sku])
            end
          end
        end
      end
    end
  end
end
