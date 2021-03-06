require 'rest_client'  # because the gem name is rest-client
require 'net/http'
require 'net/https'
require 'uri'

require "payplug/engine"
require "payplug/exceptions"
require "payplug/cart"
require "payplug/item"
require "payplug/gateway"
require "payplug/paypal"
require "payplug/google_checkout"
require "payplug/amazon_checkout"

module Payplug

  mattr_accessor :env
  @@env = "development"
  
  mattr_accessor :cart_klass
  @@cart_klass = nil
  
  mattr_accessor :item_klass
  @@item_klass = nil
  
  mattr_accessor :gateways
  @@gateways = nil
  
  mattr_accessor :return_url
  @@return_url = nil
  
  mattr_accessor :http_basic_username
  @@http_basic_username = "payplug"
  
  mattr_accessor :http_basic_password
  @@http_basic_password = "payplug"
  
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
    config_path = "#{Rails.root}/config/payplug/payplug.yml"
    @@config = YAML.load_file(config_path)[Payplug.env]
  end
  
  def self.find_cart(id)
    original_cart = @@cart_klass.find(id)
    extended_cart = original_cart.extend(Payplug::Cart)
  end
  
end
