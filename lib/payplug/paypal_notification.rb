module Payplug
 
 autoload :Notification, File.expand_path("../../../app/models/payplug/notification.rb", __FILE__)
    
 class PaypalNotification < Notification
   include PaypalParams
   
   def self.preprocess(parameters)
     pn = self.new(:raw_params=>parameters, :gateway=>"paypal")
   end
   
   def acknowledgement
     {:text => "ok"}
   end
   
   def error_response
     { :status => 500, 
       :text => "Error" }
   end       

   def process
     save_as(:processing)
     if perform_checks
       initiate_delivery
     end
     save_as(:processed)
   end

   def perform_checks
     actionability_check &&
     genuineness_check &&
     payment_complete?  
   end

   def initiate_delivery
     cart.success  
   end

   def actionability_check
     !test_ipn_in_production? &&
     has_cart? && 
     has_payment_status? 
   end
   
   def test_ipn_in_production?
     Payplug.env=="production" && test_ipn?
   end
   
   def genuineness_check
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
       else            ; raise NotificationVerificationError
     end  
   end
   
   def validated_internally
     # Check if payment_status is Completed 
     # If payment_status is completed, check if it is not duplicate
     # Check if receiver_email has correct email id
     # Check the price, in mc_gross, and currency, in mc_currency, are correct
     # Source: Paypal Order Management Integration Guide - p28
     has_correct_receiver_email? &&
     has_correct_amount? &&
     !is_false_duplicate?
   end 
   
   # A notification about a complete txn that is duplicate of a complete txn is definetely rogue
   def is_false_duplicate?
     payment_complete? && has_completed_duplicates?
   end
   
   def has_completed_duplicates?
     PaypalNotification.duplicates(self).any? {|n| n.payment_complete?}
   end
   
   def has_correct_receiver_email?
     receiver_email == Payplug::Paypal.business
   end
   
   def has_correct_amount?
     (order_amount_matches? && order_currency_matches?) or raise OrderAmountMismatchException
   end       
   
            
 end
end