class Order < ActiveRecord::Base
  has_many :line_items
  
  def self.payplug_transform 
    {  :identifier => :id,
       :total_amount => :amount    }
  end
  
end
