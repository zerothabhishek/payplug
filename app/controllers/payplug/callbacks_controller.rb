module Payplug
  class CallbacksController < ApplicationController
    
    # GET /payplug/paypal
    # POST /payplug/paypal
    def paypal
      render :text => "hi from paypal callback handler"
    end
    
    # GET /payplug/google
    # POST /payplug/google
    def google
      render :text => "hi from google callback handler"
    end
    
    # GET /payplug/amazon
    # POST /payplug/amazon
    def amazon
      render :text => "hi from amazon callback handler"
    end
    
  end
end