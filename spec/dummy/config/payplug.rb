
Payplug.init do |config|
  config.gateways = [:paypal, :google_checkout, :amazon_checkout]
  config.cart_klass = Order
  config.item_klass = LineItem
  config.return_url = "/thanks"
end