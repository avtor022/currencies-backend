class CurrenciesController < ApplicationController
  after_action :update_cache, only: [:create_forcing, :destroy_forcing]

  def index
    get_currencies
    if @currencies.nil? || @currencies[:dt].nil? || @currencies[:et].nil?
      :get_currencies
    else
      render json: {
        success: true,
        currencies: @currencies
      }
    end
  end

  def create_forcing
    index_forcing if Currency.new(currency_params).save
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
      index_forcing
    end
  end

  private

  def get_currencies
    update_cache if Currency.update_cache?
    @currencies = { 'dt': Currency.from_cache['current_dollar'], 'et': Currency.from_cache['current_euro'] }
  end

  def update_cache
    currency_forcing = Currency.forcing_current
    dt = get_currency_value(currency_forcing[:dollar], CurrencyFromSite.get_data.css('tr')[1])
    Currency.update_in_cache({currency_type: 'dollar', currency_value: dt[:currency_value], forcing_date: dt[:valid_until]})
    et = get_currency_value(currency_forcing[:euro], CurrencyFromSite.get_data.css('tr')[2])
    Currency.update_in_cache({currency_type: 'euro', currency_value: et[:currency_value], forcing_date: et[:valid_until]})
    @currencies = { 'dt': dt[:currency_value], 'et': et[:currency_value] }
  end

  def get_currency_value(currency_forcing, currency_from_site)
    currency_value, valid_until =
      if currency_forcing
        [currency_forcing.currency_value, currency_forcing.forcing_date.at_end_of_day]
     else
       [currency_from_site.css('td')[2].text.scan(/\d{1,5}\,\d{1,5}/)[0], (Time.now + 1.day).at_beginning_of_day]
     end
    { currency_value: currency_value, valid_until: valid_until }
  end

  def currency_params
    params.require(:currency_forcing_data).permit(:currency_type, :currency_value, :forcing_date)
  end
end
