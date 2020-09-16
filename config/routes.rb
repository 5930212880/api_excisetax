Rails.application.routes.draw do
  get '/form_data/fetch_data'
  get 'form_data', to: 'form_data#index'
  post 'form_data', to: 'form_data#create'
  get 'form_data/:id', to: 'form_data#show'
end
