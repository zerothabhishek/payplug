Gem::Specification.new do |s|
  s.name = "payplug"
  s.summary = "Engine for integrating payment gateways"
  s.description = "Payplug rails engine: integrates Paypal and Google Checkout with rails applications"
  s.authors = "Abhishek"
  s.homepage = "http://github.com/zerothabhishek/payplug"
  s.email = "zerothabhishek@gmail.com"
  
  s.files = Dir["{app,config,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"
  
  s.add_dependency "rest-client", '1.6.3'
  s.add_development_dependency "rspec", "~> 2.6.0"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "mocha", "~> 0.9"
  s.add_development_dependency "capybara", '1.0.0'
  s.add_development_dependency "ruby-debug19", '0.11.6'
  s.add_development_dependency "sqlite3"
end
