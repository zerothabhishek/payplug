module Payplug
  class Notification < ActiveRecord::Base
    
    def self.has_duplicates?(n, method)    
      duplicates(n).any? &method
    end
    
    def self.duplicates(n)
      Notification.where(:transaction_id=>n.transaction_id, :gateway => n.gateway)
    end
    
  end
end
