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
      notification = Payplug::GoogleCheckoutNotification.new(:gateway => "google_checkout")
      notification.params = request.env["rack.request.form_hash"]
      notification.save(:as=>:unprocessed)
      
      notification.pre_process!
      notification.process
      render_acknowledgement      
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

    def render_acknowledgement
      render :status=>200, :content_type=>'text/xml', :text=>"<notification-acknowledgment xmlns=\"http://checkout.google.com/schema/2\"  serial-number=\"123\" />"
    end
    
    
  end
end