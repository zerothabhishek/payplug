module Payplug  
  module Item
     
     def self.extended(base)    # extend callback
       method_map = base.class.payplug_transform
       method_map.each_pair do |required_method, existing_method|
         self.send(:define_method, required_method) do          # self here is the Payplug::Item module itself
           self.send(existing_method)                           # self here is the object that is getting extended
         end
       end
     end
        
  end
end