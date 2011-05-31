module Payplug
  class Paypal < Gateway
    
    cattr_accessor :email
    @@email = ""
    
    cattr_accessor :cmd
    @@cmd = "_cart"

    cattr_accessor :upload
    @@upload = "1"
    
    cattr_accessor :notify_url
    @@notify_url = nil   

    cattr_accessor :submit_url
    @@submit_url = ""   
    
    def self.init
      @@email = Payplug.config["paypal"]["email"]
      @@secret = Payplug.config["paypal"]["secret"]
      @@notify_url = Payplug.return_url   
    end
    
  end
end
    