# frozen_string_literal: true

require_relative '../app/shopping_cart'

describe ShoppingCart do
  let(:pricing_rules) { [] }
  let(:cart) { described_class.new(pricing_rules) }

  describe '#scan' do
    subject { -> { cart.scan(item) } }
    let(:item) { nil }

    context 'with no rules' do
      it { is_expected.to raise_error('invalid sku') }
    end
  end
end
