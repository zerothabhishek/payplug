
Payplug.settings = {
  :gateways => [:paypal, :google_checkout, :amazon_checkout],
  :cart => {:klass => Order, :items => "line_items", :return_url => ""},

  :cart_map => { :total_amount => "amount", :id => "id", :currency => "currency" },
  :item_map => { :price => "cost", :quantity => "qty", :name => "name", :id => "id" }
}

Payplug.init