class LineItem < ActiveRecord::Base
  
  def self.payplug_transform 
    { :identifier => :id,
      :item_name => :xyz_name,
      :item_description => :desc,
      :item_price => :price,
      :item_quantity => :qty  }
  end
  
  def desc
    "description for the item"
  end

end
