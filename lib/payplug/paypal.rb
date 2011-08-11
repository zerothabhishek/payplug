require File.expand_path("../paypal_params", __FILE__)
require File.expand_path("../paypal_notification", __FILE__)

module Payplug
  class Paypal < Gateway

    OtherPaymentStatuses = ["Canceled_Reversal", "Completed", "Created", "Denied", "Expired", "Failed", "Pending", "Refunded", "Reversed", "Processed", "Voided"]    
    Completed = "Completed"
    
    cattr_accessor :business
    @@business = ""
    
    cattr_accessor :cmd
    @@cmd = "_cart"

    cattr_accessor :upload
    @@upload = "1"
    
    cattr_accessor :notify_url
    @@notify_url = ""

    cattr_accessor :return
    @@return = ""

    cattr_accessor :submit_url
    @@submit_url = "https://www.paypal.com/cgi-bin/webscr"
    @@sandbox_url = "https://www.sandbox.paypal.com/cgi-bin/webscr"
    
    cattr_accessor :verification_host
    @@verification_host = "www.paypal.com"
    @@verification_host_in_sandbox = "www.sandbox.paypal.com"  
    
    cattr_accessor :verification_path
    @@verification_path = "/cgi-bin/webscr?"
    
    def self.init
      @@business    = Payplug.config["paypal"]["email"]
      @@secret      = Payplug.config["paypal"]["secret"]
      @@return      = Payplug.return_url
      @@notify_url  = Payplug.config["callback_host"] + "/paypal"
                     # Removed the below because routes are drawn (paypal_url) after Paplug initialization
                     # Payplug::Engine.routes.url_helpers.paypal_url(:host=>Payplug.config["callback_host"])   
      
      unless (Rails.env=="production") 
        @@submit_url  = @@sandbox_url
        @@verification_host =  @@verification_host_in_sandbox
      end
    end
    
  end  
end
    