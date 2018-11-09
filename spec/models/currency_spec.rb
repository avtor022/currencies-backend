require "rails_helper"

RSpec.describe Currency, type: :model do
  context "Add Currency" do
    describe "validations" do
      it { is_expected.to validate_presence_of(:currency_value) }
      it { is_expected.to validate_presence_of(:forcing_date) }
      it { is_expected.to validate_inclusion_of(:currency_type).in_array(%w[dollar euro])}
    end

    it "validation error" do
      currency = build(:currency, forcing_date: "non datetime")
      currency.valid?
      expect(currency.errors[:forcing_date].first).to eq("must be a datetime")
    end

    it "is valid with valid attributes" do
      currency = build(:currency)
      expect(currency).to be_valid
    end
  end
end