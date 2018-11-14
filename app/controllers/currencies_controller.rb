class CurrenciesController < ApplicationController
  after_action :update_cache, only: [:create_forcing, :destroy_forcing]

  def index
    get_currencies
    if get_currencies?
      render json: {
        success: false,
        msg: 'Error: there is no data'
      }
    else
      render json: {
        success: true,
        currencies: @currencies
      }
    end
  end

  def create_forcing
    if Currency.new(currency_params).save
      index_forcing
    else
      render json: {
        success: false,
        msg: @currencies.errors.first.last
      }
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
      index_forcing
    else
      render json: {
        success: false,
        msg: @currencies.errors.first.last
      }
    end
  end

  private

  def get_currencies
    update_cache if Currency.update_cache?
    @currencies = { 'dollar': Currency.from_cache['current_dollar'], 'euro': Currency.from_cache['current_euro'] }
  end

  def update_cache
    currency_forcing = Currency.forcing_current
    dollar = get_currency_value(currency_forcing[:dollar], CurrencyFromSite.current_dollar)
    Currency.update_in_cache({currency_type: 'dollar', currency_value: dollar[:currency_value], forcing_date: dollar[:valid_until]})
    euro = get_currency_value(currency_forcing[:euro], CurrencyFromSite.current_euro)
    Currency.update_in_cache({currency_type: 'euro', currency_value: euro[:currency_value], forcing_date: euro[:valid_until]})
    @currencies = { 'dollar': dollar[:currency_value], 'euro': euro[:currency_value] }
  end

  def get_currency_value(currency_forcing, currency_from_site)
    currency_value, valid_until =
      if currency_forcing
        [currency_forcing.currency_value, currency_forcing.forcing_date.at_end_of_day]
     else
       [currency_from_site, (Time.now + 1.day).at_beginning_of_day]
     end
    { currency_value: currency_value, valid_until: valid_until }
  end

  def get_currencies?
    @currencies.nil? ||
    @currencies[:dollar].nil? ||
    @currencies[:euro].nil?
  end

  def currency_params
    params.require(:currency_forcing_data).permit(:currency_type, :currency_value, :forcing_date)
  end
end
