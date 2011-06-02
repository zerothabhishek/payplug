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
      @@submit_url = "https://checkout.google.com/api/checkout/v2/checkoutForm/Merchant/"           # + merchant_id
      @@sandbox_url = "https://sandbox.google.com/checkout/api/checkout/v2/checkoutForm/Merchant/"  # + merchant_id
      
      def self.init
        @@merchant_id = Payplug.config["google_checkout"]["merchant_id"]
        @@merchant_key = Payplug.config["google_checkout"]["merchant_key"]

        @@submit_url = @@sandbox_url unless (Rails.env=="production")
        @@submit_url = "#{@@submit_url}#{@@merchant_id}"
      end      
      
    end
  end
end