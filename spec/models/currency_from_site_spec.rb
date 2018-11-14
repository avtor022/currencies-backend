require 'rails_helper'

RSpec.describe CurrencyFromSite do
  it "returns dollar: Float" do
    expect(CurrencyFromSite.current_dollar).to be_kind_of(Float)
  end
  it "returns euro: Float" do
    expect(CurrencyFromSite.current_euro).to be_kind_of(Float)
  end
end
