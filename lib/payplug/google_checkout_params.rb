module Payplug
  module GoogleCheckoutParams 

    ## checkers
    def serial_number_notification?
       notification_type.nil? && !serial_number.nil?
    end
    
    def new_order_notification?
      notification_type == "new-order-notification"
    end
    
    def authorization_amount_notification?
      notification_type == "authorization-amount-notification"
    end
    
    def order_state_change_notification?
      notification_type == "order-state-change-notification"
    end  
    
    def order_chargeable?
      financial_order_state == "CHARGEABLE"
    end
    
    def order_amount_matches?
      # This should allow Floats compared with FixNum
      authorization_amount.to_f == cart.total_amount
    end    

    def order_currency_matches?
      authorization_currency == cart.currency
    end
    
    
    ## getters
    def serial_number
      params and params["serial-number"]
    end

    def notification_type
      params and params["_type"]
    end
     
    def google_order_number
      params and params["google-order-number"]
    end    

    def financial_order_state
      params and params["order-summary.financial-order-state"]
    end

    def authorization_amount
      params and params["authorization-amount"]
    end
    
    def authorization_currency
      params and params["authorization-amount.currency"]
    end
    
    def cart_id
      params and params["order-summary.shopping-cart.merchant-private-data"]
    end
    
    def cart
      super(cart_id.to_i)
    end
    
  end
end