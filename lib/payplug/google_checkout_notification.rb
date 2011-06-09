module Payplug

  autoload :Notification, File.expand_path("../../../app/models/payplug/notification.rb", __FILE__)
  
  class GoogleCheckoutNotification < Notification
    @full_notification = ""
    
    ####### Pre processing ###########
    def pre_process!
      raise UnknownNotificationException if !serial_number_notification?      
      fetch_full_notification
      params.merge!(@full_notification)
    end

    def serial_number_notification?
      notification_type.nil? && !serial_number.nil?
    end
    
    def serial_number
      params["serial-number"]
    end
    
    def notification_type
      params["_type"]
    end

    def fetch_full_notification
      url = Payplug::GoogleCheckout.notification_history_url
      data = { "_type"=>"notification-history-request", "serial-number"=>serial_number}
      args = { :url=>url, 
               :payload=>data,
               :method=>:post,
               :user=>Payplug::GoogleCheckout.merchant_id, 
               :password=>Payplug::GoogleCheckout.merchant_key }
      response = RestClient::Request.execute(args)                     
      @full_notification = Rack::Utils.parse_query(response)
    end

    ####### Processing ###########
    def process      
      case notification_type
      when "new-order-notification";             handle_new_order_notification
      when "authorization-amount-notification";  handle_authorization_amount_notification
      else ;                                     handle_other_notifications 
      end
    end

    def handle_new_order_notification
      save(:as=>:new, :txn=>google_order_number)
    end
    
    def handle_authorization_amount_notification
      perform_necessary_checks
      intiate_delivery
      post_charge_command
    end
    
    def handle_other_notification
      # log it
      save(:as=>:unhandled)
    end
    
    def perform_necessary_checks
      unless order_chargeable?
        raise "Inconsistend financial-order-state in authorization-amount-notification" 
      end
      if !order_amount_matches? || !order_currency_matches?
        raise "Order amount mismatch in authorization-amount-notification"
      end
    end
    
    def initiate_delivery
      cart.success      
    end
    
    def post_charge_command
      url = Payplug::GoogleCheckout.order_processing_url
      data = { 
        "_type"=>"charge-and-ship-order", 
        "google-order-number"=> google_order_number, 
        "amount"=> authorized_amount, 
        "amount.currency"=>authorized_currency, 
        "send-email"=>"true" 
      }
      args = { 
        :url=>url, 
        :payload=>data,
        :method=>:post,
        :user=>Payplug::GoogleCheckout.merchant_id, 
        :password=>Payplug::GoogleCheckout.merchant_key 
      }

      response = RestClient::Request.execute(args)                        
      raise ChargeCommandFailedException unless charge_command_response_valid?(response)         
    end

    def google_order_number
      params["google-order-number"]
    end    
    
    def order_chargeable?
      financial_order_state == "CHARGEABLE"
    end
    
    def financial_order_state
      params["order-summary.financial-order-state"]
    end

    def order_amount_matches?
      authorized_amount == cart.amount
    end
    
    def authorized_amount
      params["authorization-amount"]
    end
    
    def order_currency_matches?
      authorized_currency == cart.currency
    end
    
    def authorized_currency
      params["authorization-amount.currency"]
    end
  
    def charge_comman_response_valid?(response)
      response_hash = Rack::Utils.parse_query(response)
      response_hash["_type"] == "request-received"
    end
    
    def cart
      @cart ||= GoogleCheckout.find_cart(cart_id)
    end
    
  end
end