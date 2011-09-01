Payplug::Engine.routes.draw do
  
  match '/paypal' => "callbacks#paypal", :as => "paypal"
  match '/google' => "callbacks#google", :as => "google"
  match '/amazon' => "callbacks#amazon", :as => "amazon"
  match '/thanks' => "carts#thanks", :as =>"thanks"  
  
  #match '/carts' => 'carts#index', :as => 'carts'
  #match '/cart/:id' => "carts#show", :as => "cart"
  #match '/cart/:id/details' => 'carts#details', :as => 'cart_details'
  resources :carts do
    get 'details', :on => :member
  end
  
  resources :notifications
end
