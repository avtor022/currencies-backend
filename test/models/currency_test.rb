require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  test "should save Currency forcing" do
    currency = Currency.new('currency_type': 'dollar', 'currency_value': 90.4, 'forcing_date': Date.tomorrow)
    assert currency.save
  end
end
