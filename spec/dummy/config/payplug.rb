
Payplug.init do |config|
  config.gateways = [:paypal, :google_checkout, :amazon_checkout]
  config.cart_klass = Order
  config.item_klass = LineItem
  config.return_url = "http://127.0.0.1:3000/thanks"
end