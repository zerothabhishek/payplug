module Payplug
  class Notification < ActiveRecord::Base
    serialize :params
    
    def self.has_duplicates?(n, method)    
      duplicates(n).any? &method
    end
    
    def self.duplicates(n)
      Notification.where(:transaction_id=>n.transaction_id, :gateway => n.gateway)
    end
    
    def save(save_hash={})
      self.status = save_hash[:as]
      self.transaction_id = save_hash[:txn]
      self.type = save_hash[:type]
      super
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
    	  save(:as=>:success)
    	  cart.success
    	  save(:as=>:processed)
      elsif some_other_status?
    	  save(:as=>:not_success)
    	  cart.handle_other_notification
    	  save(:as=>:processed)
      end          
    end
    
  end
end
