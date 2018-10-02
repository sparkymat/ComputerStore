# frozen_string_literal: true

class PricingRule
  RULE_TYPES = %i(
    x_for_y
    bulk_discount
    free_items
  ).freeze

  def initialize(rule_type:, trigger_value:, deal_value:, deal_item:)
    @rule_type     = rule_type
    @trigger_value = trigger_value
    @deal_value    = deal_value
    @deal_item     = deal_item
  end

  def apply(sku:, price_cents:, count:)
    case @rule_type
    when :x_for_y
      items = []
      items << { sku: sku, count: count }
      apply_times = count / @trigger_value
      remaining = count % @trigger_value

      deal_cents = apply_times * @deal_value * price_cents
      remaining_cents = remaining * price_cents

      total_cents = deal_cents + remaining_cents

      result = {
        items:       items,
        total_cents: total_cents,
      }
    when :bulk_discount
    when :free_items
    else
      raise 'unknown rule type'
    end

    result
  end
end
