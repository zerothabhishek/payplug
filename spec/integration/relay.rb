require 'net/http'
require 'uri'
require 'yaml'

gateway = ARGV[0]
notification_id = ARGV[1]

url = "http://payplug-callback.heroku.com/payplug/#{notification_id}"

response = Net::HTTP.get(URI.parse(url))

params_yaml = response
params_hash = YAML::load(params_yaml)
url = "http://localhost:3000/payplug/#{gateway}"

p "Posting ======>"
p "#{params_hash}. "
p "for the notification #{gateway}:#{notification_id}"
p "to #{url}"

response = Net::HTTP.post_form(URI.parse(url), params_hash)