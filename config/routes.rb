Rails.application.routes.draw do
  resources :images

  post 'upload'=>'images#upload'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
