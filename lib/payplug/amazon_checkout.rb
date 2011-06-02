module Payplug
  class AmazonCheckout < Gateway
    cattr_accessor :email
    @@email = ""

    cattr_accessor :cmd
    @@cmd = "_cart"

    cattr_accessor :upload
    @@upload = "1"

    cattr_accessor :submit_url
    @@submit_url = ""
    
    def self.init
      @@email = Payplug.config["amazon_checkout"]["email"]
      @@secret = Payplug.config["amazon_checkout"]["secret"]
    end  
  end
end