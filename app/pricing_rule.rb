# frozen_string_literal: true

class PricingRule
  def initialize(rule_type:, trigger_value:, deal_value:, deal_item:)
    @rule_type = rule_type
    @trigger_value = trigger_value
    @deal_value = deal_value
    @deal_item = deal_item
  end

  def apply(sku:, price_cents:, count:)
  end
end
