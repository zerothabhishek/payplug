module Payplug
  class GoogleCheckout < Gateway
    
    cattr_accessor :checkout_host
    @@checkout_host = "https://checkout.google.com"
    @@sandbox_host = "https://sandbox.google.com/checkout"
      
    cattr_accessor :merchant_id
    @@merchant_id = ""
    
    cattr_accessor :merchant_key
    @@merchant_key = ""
    
    cattr_accessor :submit_url
    @@submit_url = ""
    
    cattr_accessor :button_url
    @@button_url = ""
    
    cattr_accessor :notification_history_url
    @@notification_history_url
    
    cattr_accessor :order_processing_url
    @@order_processing_url
    
    def self.init
      @@merchant_id = Payplug.config["google_checkout"]["merchant_id"]
      @@merchant_key = Payplug.config["google_checkout"]["merchant_key"]
    
      unless (Rails.env=="production")
        @@checkout_host = @@sandbox_host
      end
      @@submit_url = "#{@@checkout_host}/api/checkout/v2/checkoutForm/Merchant/#{@@merchant_id}"
      @@button_url = "#{@@checkout_host}/buttons/checkout.gif?merchant_id=#{@@merchant_id}&w=180&h=46&style=white&variant=text&loc=en_US"
      @@notification_history_url = "#{@@checkout_host}/api/checkout/v2/reportsForm/Merchant/#{@@merchant_id}"
      @@order_processing_url = "#{@@checkout_host}/api/checkout/v2/requestForm/Merchant/#{@@merchant_id}"
    end      
      
  end
end