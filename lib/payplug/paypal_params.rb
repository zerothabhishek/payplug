module Payplug
  module PaypalParams
    
    ## Checkers

    def has_cart?
      txn_type=="cart" && 
      !cart_id.nil?
    end
    
    def has_payment_status?
      !payment_status.nil?
    end    
    
    def payment_complete?
      payment_status == Paypal::Completed
    end
    
    def other_payment_status?
      Paypal::OtherPaymentStatuses.include?(payment_status)    
    end  
    
    def resend?
      resend == "true"
    end
    
    def test_ipn?
      !params["test_ipn"].nil?
    end
    
    def order_amount_matches?
      mc_gross.to_f == cart.total_amount
    end
    
    def order_currency_matches?
      mc_currency == cart.currency
    end
    
    ## Getters
    def resend
      params["resend"]
    end
    
    def mc_gross
      params["mc_gross"]
    end
    
    def mc_currency
      params["mc_currency"]
    end
    
    def receiver_email
      params["receiver_email"]
    end
    
    def payment_status
      params["payment_status"]
    end
   
    def txn_type
      params["txn_type"]
    end
   
    def cart_id
      params["invoice"]
    end
    
    def cart
      @cart ||= Payplug.find_cart(cart_id)
    end    
  end
end