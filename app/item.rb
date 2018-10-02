# frozen_string_literal: true

require 'ostruct'

class Item
  attr_reader :sku

  DETAILS = {
    'ipd' => {
      name: 'Super iPad',
      price_cents: 549_99,
    },
    'mbp' => {
      name: 'MacBook Pro',
      price_cents: 1_399_99,
    },
    'atv' => {
      name: 'Apple TV',
      price_cents: 109_50,
    },
    'vga' => {
      name: 'VGA adapter',
      price_cents: 30_00,
    },
  }.freeze

  def initialize(sku)
    @sku = sku
  end

  def details
    @details ||= OpenStruct.new(self.inspect)

    @details
  end

  def inspect
    DETAILS[@sku].merge(sku: @sku)
  end
end
