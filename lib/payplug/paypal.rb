module Payplug
  class Paypal < Gateway
    
    cattr_accessor :email
    @@email = ""
    
    cattr_accessor :cmd
    @@cmd = "_cart"

    cattr_accessor :upload
    @@upload = "1"
    
    def self.notify_url
      paypal_url
    end
    
    def self.submit_url      
    end
    
  end
end
    