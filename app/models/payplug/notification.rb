module Payplug
  class Notification < ActiveRecord::Base
    serialize :params
    
    def self.has_duplicates?(n, method)    
      duplicates(n).any? &method
    end
    
    def self.duplicates(n)
      Notification.where(:transaction_id=>n.transaction_id, :gateway => n.gateway)
    end
    
    def save_as(status_given=nil)
      self.status = status_given
      save
    end
        
    def cart(id)
      begin
        @cart ||= Payplug.find_cart(id)
      rescue
        raise CartNotFoundException 
      end  
    end
    
    def process
      if payment_complete?
    	  save_as(:success)
    	  cart.success
    	  save_as(:processed)
      elsif some_other_status?
    	  save_as(:not_success)
    	  cart.handle_other_notification
    	  save_as(:processed)
      end          
    end
    
  end
end
