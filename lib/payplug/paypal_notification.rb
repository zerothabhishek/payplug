module Payplug
 
 autoload :Notification, File.expand_path("../../../app/models/payplug/notification.rb", __FILE__)
    
 class PaypalNotification < Notification

  ####### actionable ###########  
  def actionable?
    has_cart? && 
    has_payment_status? && 
    !is_test?
  end
  
  def has_cart?
    (params[:txn_type]=="cart") && (params[:invoice] != "" )
  end
  
  def has_payment_status?
    payment_status != ""
  end
  
  def is_test?
    Rails.env=="production" && params["test_ipn"] !=""
  end
  
  def get_actionable_notification
    # Paypal does not send non-actionable notifications
    # If there is one that looks non-actionable, just log and exit
    nil
  end

  ####### genuine ###########  
  def genuine?
    validated_from_paypal && validated_internally
  end

  def validated_from_paypal    
    parameters = params.merge({"cmd"=>"_notify-validate"})
    http = Net::HTTP.new(Paypal.verification_host, 443)
    http.use_ssl = true
    path = "#{Paypal.verification_path}#{parameters.to_query}"
    response, response_data = http.get(path)
    case response_data
      when 'VERIFIED' ; return true      
      when 'INVALID'  ; return false
      else            ; raise "Can't validate this notification - #{id}"  
    end  
  end
  
  def validated_internally
    # Check if payment_status is Completed 
    # If payment_status is completed, check if it is not duplicate
    # Check if receiver_email has correct email id
    # Check the price, in mc_gross, and currency, in mc_currency, are correct
    # Source: Paypal Order Management Integration Guide - p28
    has_correct_receiver_email? &&
    has_correct_cart? &&
    !is_false_duplicate?
  end 
  
  # A notification about a complete txn that is duplicate of a complete txn is definetely rogue
  def is_false_duplicate?
    payment_complete? && has_completed_duplicates?
  end
  
  def has_completed_duplicates?
    PaypalNotification.has_duplicates?(self, :payment_complete?)
  end
  
  def has_correct_receiver_email?
    params["receiver_email"] == Payplug::Paypal.business
  end
  
  def has_correct_cart?
    params["mc_gross"] == cart.total_amount &&
    params["mc_currency"] == cart.currency 
  end       

  ####### resend ###########  
  def resend?
    params["resend"] == true
  end
  

  ####### process ###########      
  def payment_complete?
    payment_status == Paypal::Completed
  end

  def some_other_status?
    Paypal::OtherPaymentStatuses.include?(payment_status)    
  end  
  
  def cart
    @cart ||= Payplug.find_cart(cart_id)
  end

  def payment_status
    @payment_status ||= params["payment_status"]
  end
            
 end
end