module Payplug
  module Cart  
    
    def self.extended(base)    # extend callback
      method_map = base.class.payplug_transform
      method_map.each_pair do |required_method, existing_method|
        self.send(:define_method, required_method) do          # self here is the Payplug::Cart module itself
          self.send(existing_method)                           # self here is the object that is getting extended
        end
      end
    end
        
    def items
      method_name = Payplug.item_klass.to_s.underscore.pluralize            # getting line_items from LineItem
      original_items = self.send(method_name)                               # @cart.line_items
      extended_items = original_items.map{|i| i.extend(Payplug::Item) }     # extend each item with Payplug::Item
      extended_items
    end
      
  end
end