# frozen_string_literal: true

describe PricingRule do
  let(:pricing_rule) { described_class.new(rule_type: rule_type, trigger_value: trigger_value, deal_value: deal_value, deal_item: deal_item) }

  describe '#apply' do
    subject(:apply_rule) { pricing_rule.apply(sku: sku, price_cents: price_cents, count: count) }

    context 'x for y deal' do
      let(:rule_type)     { :x_for_y }
      let(:trigger_value) { 3        }
      let(:deal_value)    { 2        }
      let(:deal_item)     { nil      }

      let(:sku)           { 'atv'    }
      let(:count)         { 3        }
      let(:price_cents)   { 109_50   }

      it 'returns the calculated item list and total' do
        result = apply_rule
        expect(result).to_not be_nil
        expect(result[:items]).to contain_exactly(sku: 'atv', count: 3)
        expect(result[:total_cents]).to eq 109_50 * 2
      end
    end

    context 'bulk discount' do
      let(:rule_type)     { :bulk_discount }
      let(:trigger_value) { 4        }
      let(:deal_value)    { 499_99   }
      let(:deal_item)     { nil      }

      let(:sku)           { 'ipd'    }
      let(:count)         { 7        }
      let(:price_cents)   { 549_99   }

      it 'returns the calculated item list and total' do
        result = apply_rule
        expect(result).to_not be_nil
        expect(result[:items]).to contain_exactly(sku: 'ipd', count: 7)
        expect(result[:total_cents]).to eq 499_99 * 7
      end
    end

    context 'free items' do
      let(:rule_type)     { :free_items }
      let(:trigger_value) { 1           }
      let(:deal_value)    { 1           }
      let(:deal_item)     { 'vga'       }

      let(:sku)           { 'mbp'    }
      let(:count)         { 2        }
      let(:price_cents)   { 1399_99  }

      it 'returns the calculated item list and total' do
        result = apply_rule
        expect(result).to_not be_nil
        expect(result[:items]).to contain_exactly({ sku: 'mbp', count: 2 }, { sku: 'vga', count: 2 })
        expect(result[:total_cents]).to eq 1_399_99 * 2
      end
    end
  end
end
