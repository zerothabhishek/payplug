module Payplug
  class Paypal < Gateway
    
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
    
    def self.init
      @@business    = Payplug.config["paypal"]["email"]
      @@secret      = Payplug.config["paypal"]["secret"]
      @@return      = Payplug.return_url
      @@notify_url  = Payplug::Engine.routes.url_helpers.paypal_url(:host=>Payplug.config["callback_host"])   
      @@submit_url  = @@sandbox_url unless (Rails.env=="production") 
    end
    
  end  
end
    