require "payplug/engine"
require "payplug/cart"
require "payplug/gateway"
require "payplug/paypal"
require "payplug/google_checkout"

module Payplug
  
  mattr_accessor :settings
  @@settings = {}
  
  def self.init
    cart_klass = @@settings[:cart][:klass]  
    cart_klass.send(:include, Payplug::Cart)
    Payplug::Cart.cart_map = @@settings[:cart_map]
  end
  
  def notify_url
  end
  
end
