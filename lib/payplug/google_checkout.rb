require File.expand_path("../google_checkout_params", __FILE__)
require File.expand_path("../google_checkout_notification", __FILE__)

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
      @@checkout_host = @@sandbox_host  unless (Payplug.env=="production")
      
      @@submit_url = "#{@@checkout_host}/api/checkout/v2/checkoutForm/Merchant/#{@@merchant_id}"
      @@button_url = "#{@@checkout_host}/buttons/checkout.gif?merchant_id=#{@@merchant_id}&w=180&h=46&style=white&variant=text&loc=en_US"
      @@notification_history_url = "#{@@checkout_host}/api/checkout/v2/reportsForm/Merchant/#{@@merchant_id}"
      @@order_processing_url = "#{@@checkout_host}/api/checkout/v2/requestForm/Merchant/#{@@merchant_id}"
    end    
    
    def self.notification_klass(n_type)
      case n_type
        when "new-order-notification"             ; NewOrderNotification
        when "authorization-amount-notification"  ; AuthorizationAmountNotification
        when "order-state-change-notification"    ; OrderStateChangeNotification
        else                                      ; GoogleCheckoutNotification
      end
    end  
    
    
    def self.notification_type(raw_notification)
      notification_params = Rack::Utils.parse_query(raw_notification)
      notification_type = notification_params["_type"]
    end
        
  end
  
end