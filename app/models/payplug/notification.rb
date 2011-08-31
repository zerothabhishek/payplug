module Payplug
  class Notification < ActiveRecord::Base

    def self.duplicates(n)
      self.where(:transaction_id=>n.transaction_id, :gateway => n.gateway)
    end
    
    def save_as(status_given=nil)
      self.status = status_given
      save
    end
    
    def params
      @params ||= (Rack::Utils.parse_query(self.raw_params) || {})
    end
    
    def cart(id)
      begin
        @cart ||= Payplug.find_cart(id)
      rescue
        raise CartNotFoundException 
      end  
    end
    
  end
end
