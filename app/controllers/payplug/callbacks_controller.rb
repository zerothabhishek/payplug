module Payplug
  class CallbacksController < ApplicationController
    
    # POST /payplug/paypal
    def paypal
      notification = PaypalNotification.create(:params => params, :gateway => "paypal") 
      if notification.is_valid?
        notification.cart.send("handle_#{transaction_status}")  
      else
        raise "Invalid Notification recieved from paypal" 
      end
      render :nothing => true
    end
    
    # POST /payplug/google
    def google
      notification = Notification.create(:gateway => "google_checkout", :params => params)
      notification.process
      render :nothing => true
    end
    
    # POST /payplug/amazon
    def amazon
    end
    
  end
end