Rails.application.routes.draw do
  root 'home#index'

  get "embedded/signing"
  get "embedded/requesting"
  get "embedded/template_requesting"
  get "embedded/oauth_demo"
  get "home/index"

  post 'embedded/signing', to: 'embedded#create_signing'
  post 'embedded/requesting', to: 'embedded#create_requesting'
  post 'embedded/template_requesting', to: 'embedded#create_template_requesting'
  post 'embedded/oauth_demo', to: 'embedded#create_oauth_demo'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  post 'oauth', to:'oauth#index'
  get 'oauth', to:'oauth#index'
  post 'callback', to: 'home#callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
