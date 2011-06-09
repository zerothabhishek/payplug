module Payplug
  class Notification < ActiveRecord::Base
    serialize :params
    
    def self.has_duplicates?(n, method)    
      duplicates(n).any? &method
    end
    
    def self.duplicates(n)
      Notification.where(:transaction_id=>n.transaction_id, :gateway => n.gateway)
    end
    
    def save(as_hash={})
      self.notification_status = as_hash[:as]
      self.transaction_id = as_hash[:txn]
      super
    end
    
    def process
      if payment_complete?
    	  save(:as=>:success)
    	  cart.handle_success
    	  save(:as=>:processed)
      elsif some_other_status?
    	  save(:as=>:not_success)
    	  cart.handle_other_notification
    	  save(:as=>:processed)
      end          
    end
    
  end
end
