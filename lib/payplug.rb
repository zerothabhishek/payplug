require "payplug/engine"
require "payplug/cart"
require "payplug/item"
require "payplug/gateway"
require "payplug/paypal"
require "payplug/google_checkout"
require "payplug/amazon_checkout"

module Payplug
  
  mattr_accessor :cart_klass
  @@cart_klass = nil
  
  mattr_accessor :item_klass
  @@item_klass = nil
  
  mattr_accessor :gateways
  @@gateways = nil
  
  mattr_accessor :return_url
  @@return_url = nil
  
  mattr_accessor :config
  @@config = nil

  def self.init
    yield self
    read_config
    Paypal.init           #  .
    GoogleCheckout.init   #  refactor
    AmazonCheckout.init   #  .
  end
  
  def self.read_config
    config_path = "#{Rails.root}/config/payplug.yml"
    @@config = YAML.load_file(config_path)[Rails.env]
    @@config.to_options
  end
  
  def self.find_cart(id)
    original_cart = @@cart_klass.find(id)
    extended_cart = original_cart.extend(Payplug::Cart)
  end
  
end
