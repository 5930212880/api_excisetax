Rails.application.routes.draw do
  get '/form_data/fetch_data'
  get 'form_data/:formeffectivedate', to: 'form_data#index'
  # get 'form_data/:formreferencenumber', to: 'form_data#show'
 
end
