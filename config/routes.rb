Payplug::Engine.routes.draw do
  
  match '/paypal' => "callbacks#paypal", :as => "paypal"
  match '/google' => "callbacks#google", :as => "google"
  match '/amazon' => "callbacks#amazon", :as => "amazon"
  match '/cart/:id' => "carts#show", :as => "cart"
  match '/thanks' => "carts#thanks", :as =>"thanks"
end
