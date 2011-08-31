module Payplug
  class CallbacksController < ApplicationController
    
    # POST /payplug/paypal
    def paypal
      begin
        parameters = request.env["rack.request.form_hash"]
        # The rack.request.form_hash probably has bugs and has given wrong results with google checkout 
        # Replace the above line of code with the two below -
        #   parameters_str = request.raw_post
        #   parameters = Rack::Utils.parse_query(parameters_str)
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
        #parameters = request.env["rack.request.form_hash"]
        #parameters = Rack::Utils.parse_query(parameters_str)
        #
        #notification = Payplug::GoogleCheckoutNotification.preprocess(parameters)
        #notification.process
        #render notification.acknowledgement
        parameters_str = request.raw_post
        snn = SerialNumberNotification.new(:raw_params => parameters_str)
        snn.save_as(:unprocessed)
        render snn.acknowledgement

        full_notification = snn.fetch_fn
        snn.save_as(:processed)
        
        full_notification.process
      rescue PayplugException => e
        e.handle
        render notification.error_response
        #render GoogleCheckoutNotification.acknowledgement
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