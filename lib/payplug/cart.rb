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
    
    def finalize_amount
      gross_amount = self.items.map(&:item_amount).inject(:+)      
      self.apply_discounts
      self.apply_shipping_charges
      amount_attribute = Payplug.cart_klass.payplug_transform[:total_amount].to_sym
      self.update_attributes(amount_attribute => gross_amount)
    end  
    
    def apply_discounts
      true
    end
    
    def apply_shipping_charges
      true
    end
    
  end
end