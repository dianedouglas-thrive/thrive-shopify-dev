Rails.application.routes.draw do
  resources :smartpages
  get 'script/test', to: 'script#test', :defaults => { format: :js }
  # post 'smartpages', to: 'home#smartpages'
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
