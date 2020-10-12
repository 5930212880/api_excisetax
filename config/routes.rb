Rails.application.routes.draw do
  get 'form_data/:formeffectivedate', to: 'form_data#inquiry'
  get 'form_data', to: 'form_data#all'
  get 'get_data/updatedate', to: 'form_data#updatedate'
  # get 'form_data/:formreferencenumber', to: 'form_data#show'

  post 'form_data/saveformproductsource', to: 'form_data#save_form_product_source'
  post 'form_data/inquirychecklistsou', to: 'form_data#inquiry_form_product_checklist_sou'
  post 'form_data/inquirychecklistdes', to: 'form_data#inquiry_form_product_checklist_des'
  
end
