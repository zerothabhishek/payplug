Rails.application.routes.draw do

  mount Payplug::Engine => "/payplug"
end
