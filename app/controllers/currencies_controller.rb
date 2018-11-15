class CurrenciesController < ApplicationController

  def index
    if Currency.get_currencies.nil? || Currency.get_currencies[:dollar].nil? || Currency.get_currencies[:euro].nil?
      render json: {
        success: false,
        msg: 'Error: there is no data'
      }
    else
      render json: {
        success: true,
        currencies: Currency.get_currencies
      }
    end
  end

  def create_forcing
    if @currency_forcing = Currency.new(currency_params).save
      index_forcing
      Currency.get_currencies
    else
      show_error
    end
  end

  def destroy_forcing
    @currency_forcing = Currency.find(params[:id])
    if @currency_forcing.destroy
      index_forcing
      Currency.get_currencies
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
