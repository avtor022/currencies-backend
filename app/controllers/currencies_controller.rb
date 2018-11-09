class CurrenciesController < ApplicationController
  after_action :update_cache, only: [:create_forcing, :destroy_forcing]
  before_action :get_currencies, only: :index
  before_action :update_cache, only: :get_currencies if Currency.from_cache.nil? ||
                                                        Currency.from_cache['current_dollar'].nil? ||
                                                        Currency.from_cache['current_euro'].nil?

  def index
    if @currencies
      render json: {
        success: true,
        currencies: @currencies
      }
    else
      render json: {
        success: false,
        msg: "Can't get data about currencies"
      }
    end
  end

  def get_currencies
    @currencies = { 'dt': Currency.from_cache['current_dollar'], 'et': Currency.from_cache['current_euro'] }
  end

  def update_cache
    self.get_data_from_site
    currency_forcing = Currency.forcing_current
    dt = self.get_currency_value(currency_forcing[:dollar], @table.css('tr')[1])
    Currency.update_in_cache({currency_type: 'dollar', currency_value: dt[:currency_value], forcing_date: dt[:valid_until]})
    et = self.get_currency_value(currency_forcing[:euro], @table.css('tr')[2])
    Currency.update_in_cache({currency_type: 'euro', currency_value: et[:currency_value], forcing_date: et[:valid_until]})
    @currencies = { 'dt': dt[:currency_value], 'et': et[:currency_value] }
  end

  def get_data_from_site
    require 'open-uri'
    doc = Nokogiri::HTML(open("https://www.cbr.ru/"))
    @table = doc.css('table')[2]
  end

  def get_currency_value(currency_forcing, currency_from_site)
    if currency_forcing.nil?
      { currency_value: currency_from_site.css('td')[2].text.scan(/\d{1,5}\,\d{1,5}/)[0], valid_until: (Time.now + 1.day).at_beginning_of_day }
    else
      { currency_value: currency_forcing.currency_value, valid_until: currency_forcing.forcing_date.at_end_of_day }
    end
  end

  def create_forcing
    currency_forcing_data = Currency.new(currency_params)
    if currency_forcing_data.save
      self.index_forcing
    end
  end

  def index_forcing
    currency_forcing_list = Currency.all.order(id: :DESC)
    render json: {
      success: true,
      currency_forcing_list: currency_forcing_list
    }
  end

  def destroy_forcing
    currency_forcing_data = Currency.find(params[:id])
    if currency_forcing_data.destroy
      self.index_forcing
    end
  end

  private
  def currency_params
    params.require(:currency_forcing_data).permit(:currency_type, :currency_value, :forcing_date)
  end
end
