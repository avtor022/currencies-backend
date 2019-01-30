class Currency < ApplicationRecord
  CACHE_KEY_DOLLAR = 'current_dollar'.freeze
  CACHE_KEY_EURO = 'current_euro'.freeze

  after_commit { self.class.update_cache }

  validate :forcing_date_datetime
  validates :currency_type, inclusion: { in: %w(dollar euro), message: "must be 'dollar' or 'euro'" }
  validates :currency_value, :forcing_date, presence: true

  class << self
    def cache_nil?
      from_cache.nil? ||
      from_cache[CACHE_KEY_DOLLAR].nil? ||
      from_cache[CACHE_KEY_EURO].nil?
    end

    def currency_to_cache(currency_data)
      Rails.cache.write("current_#{currency_data[:currency_type]}", currency_data[:currency_value], expires_in: (currency_data[:forcing_date] - Time.now).round.seconds)
    end

    def current_value_for_cache(currency_forcing, currency_from_site)
      currency_value, valid_until =
        if currency_forcing
          [currency_forcing.currency_value, currency_forcing.forcing_date.at_end_of_day]
        else
          [currency_from_site, (Time.now + 1.day).at_beginning_of_day]
        end
        { currency_value: currency_value, valid_until: valid_until }
    end

    def forcing_current
      today = Date.today
      d = Currency.where('forcing_date >= ? AND currency_type = ?', today, 'dollar').order('forcing_date').first
      e = Currency.where('forcing_date >= ? AND currency_type = ?', today, 'euro').order('forcing_date').first
      { dollar: d, euro: e }
    end

    def from_cache
      Rails.cache.read_multi(CACHE_KEY_DOLLAR, CACHE_KEY_EURO)
    end

    def update_cache
      currency_forcing = forcing_current
      dollar = current_value_for_cache(currency_forcing[:dollar], CurrencyFromSite.current_dollar)
      currency_to_cache({currency_type: 'dollar', currency_value: dollar[:currency_value], forcing_date: dollar[:valid_until]})
      euro = current_value_for_cache(currency_forcing[:euro], CurrencyFromSite.current_euro)
      currency_to_cache({currency_type: 'euro', currency_value: euro[:currency_value], forcing_date: euro[:valid_until]})
    end

    def get_currencies
      update_cache if cache_nil?
      { 'dollar': from_cache[CACHE_KEY_DOLLAR], 'euro': from_cache[CACHE_KEY_EURO] }
    end
  end

  def forcing_date_datetime
    forcing_date.to_datetime rescue errors.add(:forcing_date, "must be a datetime")
  end
end
