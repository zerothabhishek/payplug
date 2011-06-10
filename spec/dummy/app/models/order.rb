class Order < ActiveRecord::Base
  has_many :line_items
  
  def self.payplug_transform 
    {  :identifier => :id,
       :total_amount => :amount,    
       :success => :mark_order_as_purchased,
       :processed? => :purchased? }
  end
  
  def mark_order_as_purchased
    status = "Processed"
  end
  
  def purchased?
    status == "Processed"
  end
  
end
