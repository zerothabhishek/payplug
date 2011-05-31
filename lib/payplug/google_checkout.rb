module Payplug
  class GoogleCheckout < Gateway
    def self.init
      
      cattr_accessor :email
      @@email = ""

      cattr_accessor :cmd
      @@cmd = "_cart"

      cattr_accessor :upload
      @@upload = "1"

      cattr_accessor :submit_url
      @@submit_url = ""
      
      def self.init
        @@email = Payplug.config["google_checkout"]["email"]
        @@secret = Payplug.config["google_checkout"]["secret"]
      end      
      
    end
  end
end