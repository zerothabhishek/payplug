module Payplug
  module Cart  
    
    cattr_accessor :cart_map
    @@cart_map = {}
        
    def total_amount
      items.inject{|sum, i| sum + (i.price*i.quantity) }
    end
          
    def return_url
    end      
    
    def items
      cart_klass = Payplug.settings[:cart][:klass]
      cart_items_method_name = Payplug.settings[:cart][:items].to_s
      cart_klass.send(cart_items_method_name)
    end
    
  end
end