module Payplug  
  module Item
     
     #def self.extended(base)    # extend callback
     #  method_map = base.class.payplug_transform
     #  method_map.each_pair do |required_method, existing_method|
     #    self.send(:define_method, required_method) do          # self here is the Payplug::Item module itself
     #      self.send(existing_method)                           # self here is the object that is getting extended
     #    end
     #  end
     #end
     
     #def self.extended(item_object)
     #  define_item_amount(item_object)   unless item_object.respond_to?(:item_amount)       
     #end
     #
     #def self.define_item_amount(item_object)
     #  item_object.define_singleton_method(:item_amount) do      
     #   self._item_amount                                        
     # end
     #end
     
     def identifier
       self.id
     end

     # Use this if item_obj does not respond_to item_amount 
     def _payplug_item_amount
       self.item_price * self.item_quantity
     end
        
  end
end