module Payplug
  class CallbacksController < ApplicationController
    
    # POST /payplug/paypal
    def paypal
      notification = Payplug::PaypalNotification.new(:gateway => "paypal") 
      notification.params = request.env["rack.request.form_hash"]
      notification.save(:as=>:unprocessed)
      
      if !notification.actionable?
        notification.save(:as=>:not_actionable)
        notification = notification.get_actionable_notification
        log_and_exit if notification.nil? 
      end
      
      if !notification.genuine?
        notification.save(:as=>:not_genuine)
        raise_alarm_and_exit 
      end
      
      if notification.resend?
        notification.save(:as=>:resend)
        log_and_exit
      end
      
      notification.process
      log_and_exit
    end
    
    # POST /payplug/google
    def google   
      begin
        parameters = request.env["rack.request.form_hash"]
        notification = Payplug::GoogleCheckoutNotification.preprocess(parameters)
        notification.process
        render notification.acknowledgement
      rescue => e
        p e.message
        e.backtrace.each{|line| p line }
        render :status => 500, :text => "Error"
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