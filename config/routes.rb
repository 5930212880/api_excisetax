Rails.application.routes.draw do
  get 'form_data/:formeffectivedate', to: 'form_data#inquiry'
  # get 'form_data/:formreferencenumber', to: 'form_data#show'
  post 'form_data/saveformproductsource', to: 'form_data#save_form_product_source'
  post 'form_data/inquirychecklist', to: 'form_data#inquiry_form_product_checklist'
  get 'form_data', to: 'form_data#all'
end
