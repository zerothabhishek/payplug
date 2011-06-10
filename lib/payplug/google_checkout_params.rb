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
      authorization_amount == cart.amount
    end    

    def order_currency_matches?
      authorization_currency == cart.currency
    end
    
    
    ## getters
    def serial_number
      params["serial-number"]
    end

    def notification_type
      params["_type"]
    end
     
    def google_order_number
      params["google-order-number"]
    end    

    def financial_order_state
      params["order-summary.financial-order-state"]
    end

    def authorization_amount
      params["authorization-amount"]
    end
    
    def authorization_currency
      params["authorization-amount.currency"]
    end
    
    def cart_id
      params["order-summary.shopping-cart.merchant-private-data"]
    end
    
    def cart
      super(cart_id.to_i)
    end
    
  end
end