module Payplug
  class CallbacksController < ApplicationController
    
    # POST /payplug/paypal
    def paypal
      begin
        parameters = request.env["rack.request.form_hash"]
        notification = Payplug::PaypalNotification.preprocess(parameters)
        notification.process
        render notification.acknowledgement
      rescue PayplugException => e
        e.handle
        render notification.error_response
      end
    end
    
    # POST /payplug/google
    def google   
      begin
        parameters = request.env["rack.request.form_hash"]
        notification = Payplug::GoogleCheckoutNotification.preprocess(parameters)
        notification.process
        render notification.acknowledgement
      rescue PayplugException => e
        e.handle
        render notification.error_response
      end
    end
    
    # POST /payplug/amazon
    def amazon
    end
    
    
    private
    
    def log_and_exit
      # Do some logging
      render :nothing => true
      return
    end
    
    def raise_alarm_and_exit
      # Raise some alarams -  send emails etc
      render :nothing => true
      return
    end
    
    
  end
end