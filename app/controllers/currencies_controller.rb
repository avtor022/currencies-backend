class CurrenciesController < ApplicationController

  def index
    current_currency = Currency.get_currencies
    if current_currency.nil? || current_currency[:dollar].nil? || current_currency[:euro].nil?
      render json: {
        success: false,
        msg: 'Error: there is no data'
      }
    else
      render json: {
        success: true,
        currencies: current_currency
      }
    end
  end

  def create_forcing
    if @currency_forcing = Currency.new(currency_params).save
      index_forcing
    else
      show_error
    end
  end

  def destroy_forcing
    @currency_forcing = Currency.find(params[:id])
    if @currency_forcing.destroy
      index_forcing
    else
      show_error
    end
  end

  def index_forcing
    currency_forcing_list = Currency.all.order(id: :DESC)
    render json: {
      success: true,
      currency_forcing_list: currency_forcing_list
    }
  end

  private

  def show_error
    render json: {
      success: false,
      msg: @currency_forcing.errors.first.last
    }
  end

  def currency_params
    params.require(:currency_forcing_data).permit(:currency_type, :currency_value, :forcing_date)
  end
end
