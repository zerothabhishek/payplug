require "payplug/engine"

module Payplug

  mattr_accessor :gateways
  @@gateways = []
  
  mattr_accessor :cart_class
  @@cart_class = nil
  
  mattr_accessor :item_class
  @@item_class = nil
  
  def self.setup
    yield self
  end

  def self.cart_class=(klass, mappings)
    @cart_class = klass 
  end
  
  def self.load_payplug_yaml
  end
  
end
