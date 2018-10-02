# frozen_string_literal: true

describe ShoppingCart do
  let(:pricing_rules) do
    {
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
  end
  let(:cart) { described_class.new(pricing_rules) }

  describe '#scan' do
    context 'single item' do
      subject { -> { cart.scan(item) } }

      let(:sku)  { 'atv'         }
      let(:item) { Item.new(sku) }

      it { is_expected.to change { cart.items }.from([]).to([item]) }
      it { is_expected.to change { cart.total_cents }.from(0).to(109_50) }
    end

    context '3 items to trigger x_for_y rule' do
      subject { -> { cart.scan(item1); cart.scan(item2); cart.scan(item3) } }

      let(:sku)   { 'atv'         }
      let(:item1) { Item.new(sku) }
      let(:item2) { Item.new(sku) }
      let(:item3) { Item.new(sku) }

      it { is_expected.to change { cart.items }.from([]).to([item1, item2, item3]) }
      it { is_expected.to change { cart.total_cents }.from(0).to(109_50 * 2) }
    end

    context '5 items to trigger bulk_discount rule' do
      subject { -> { cart.scan(item1); cart.scan(item2); cart.scan(item3); cart.scan(item4); cart.scan(item5) } }

      let(:sku)   { 'ipd'         }
      let(:item1) { Item.new(sku) }
      let(:item2) { Item.new(sku) }
      let(:item3) { Item.new(sku) }
      let(:item4) { Item.new(sku) }
      let(:item5) { Item.new(sku) }

      it { is_expected.to change { cart.items }.from([]).to([item1, item2, item3, item4, item5]) }
      it { is_expected.to change { cart.total_cents }.from(0).to(499_99 * 5) }
    end

    context '1 item to trigger free_items' do
      subject(:scan) { cart.scan(item) }

      let(:sku)  { 'mbp'         }
      let(:item) { Item.new(sku) }

      it 'returns the correct item list and total' do
        scan

        expect(cart.total_cents).to eq 1_399_99
        expect(cart.items.count).to eq 2
        expect(cart.items.map{ |i| i.details.sku }).to contain_exactly('mbp', 'vga')
      end
    end
  end
end
