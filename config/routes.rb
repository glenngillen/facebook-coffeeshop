FacebookCoffeeshop::Application.routes.draw do
  match 'auth/:id/callback' => 'authentication#callback', :as => :auth_callback
  match 'auth/:id' => 'authentication#login', :as => :auth
  match '/logout' => 'authentication#logout', :as => :logout
  resources :coffees
  root :to => 'welcome#index'
end
