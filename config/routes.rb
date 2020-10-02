Rails.application.routes.draw do
  get 'form_data/:formeffectivedate', to: 'form_data#index'
  # get 'form_data/:formreferencenumber', to: 'form_data#show'
  post 'form_data/saveproduct', to: 'form_data#save_from_product_source'
  get 'form_data', to: 'form_data#all'
end
