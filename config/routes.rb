Rails.application.routes.draw do
  get 'script/test', to: 'script#test', :defaults => { format: :js }
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
