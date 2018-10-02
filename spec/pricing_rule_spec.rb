# frozen_string_literal: true

require_relative '../app/pricing_rule'

describe PricingRule do
  let(:pricing_rule) { described_class.new(rule_type: rule_type, trigger_value: trigger_value, deal_value: deal_value, deal_item: deal_item) }

  describe '#apply' do
    subject(:apply_rule) { pricing_rule.apply(sku: sku, price_cents: price_cents, count: count) }

    context 'x for y deal' do
      let(:rule_type)     { :x_for_y }
      let(:trigger_value) { 3        }
      let(:deal_value)    { 2        }
      let(:deal_item)     { nil      }

      let(:sku)           { 'ipd'    }
      let(:count)         { 3        }
      let(:price_cents)   { 54_999   }

      it 'returns the calculated item list and total' do
        result = apply_rule
        expect(result).to_not be_nil
        expect(result[:items]).to contain_exactly(sku: 'ipd', count: 3)
        expect(result[:total_cents]).to eq 54_999 * 2
      end
    end
  end
end
