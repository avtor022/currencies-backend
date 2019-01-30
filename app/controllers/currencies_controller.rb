class CurrenciesController < ApplicationController

  def index
    if Currency.get_currencies[:dollar].nil? && Currency.get_currencies[:euro].nil?
      render_error()
    else
      render_currencies(Currency.get_currencies)
    end
  end

  def create_forcing
    if currency_forcing = Currency.new(currency_params).save
      index_forcing
    else
      render_error(currency_forcing.errors.first.last)
    end
  end

  def destroy_forcing
    currency_forcing = Currency.find(params[:id])
    if currency_forcing.destroy
      index_forcing
    else
      render_error(currency_forcing.errors.first.last)
    end
  end

  def index_forcing
    render_currencies(Currency.all.order(id: :DESC))
  end

  private

  def render_currencies(currencies)
    render json: {
      success: true,
      currencies: currencies
    }
  end

  def render_error(error_msg = 'There are no data!')
    render json: {
      success: false,
      msg: error_msg
    }
  end

  def currency_params
    params.require(:currency_forcing_data).permit(:currency_type, :currency_value, :forcing_date)
  end
end
