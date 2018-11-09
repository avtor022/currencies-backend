Rails.application.routes.draw do
  root 'currencies#index'
  get "/currency_forcing",  to: "currencies#index_forcing"
  post "/currency_forcing", to: "currencies#create_forcing"
  delete "/currency_forcing/:id", to: "currencies#destroy_forcing"

end
