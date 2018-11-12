class Currency < ApplicationRecord
  validate :forcing_date_datetime
  validates :currency_type, inclusion: { in: %w(dollar euro), message: "must be 'dollar' or 'euro'" }
  validates :currency_value, :forcing_date, presence: true

  class << self
    def forcing_current
      today = Date.today
      d = Currency.where('forcing_date >= ? AND currency_type = ?', today, 'dollar').order('forcing_date').first
      e = Currency.where('forcing_date >= ? AND currency_type = ?', today, 'euro').order('forcing_date').first
      { dollar: d, euro: e }
    end

    def from_cache
      Rails.cache.read_multi('current_dollar', 'current_euro')
    end

    def update_in_cache(currency_data)
      Rails.cache.write("current_#{currency_data[:currency_type]}", currency_data[:currency_value], expires_in: (currency_data[:forcing_date] - Time.now).to_i)
    end

    def update_cache?
      from_cache.nil? ||
      from_cache['current_dollar'].nil? ||
      from_cache['current_euro'].nil?
    end
  end

  def forcing_date_datetime
    forcing_date.to_datetime rescue errors.add(:forcing_date, "must be a datetime")
  end
end
