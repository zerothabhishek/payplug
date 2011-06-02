module Payplug
  class Notification < ActiveRecord::Base
        
    def process
      # 1. validate by sending a request to paypal
      # 2. if valid succeeds, see what is the status of the cart
    end
    
  end
end
