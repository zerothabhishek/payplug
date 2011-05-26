# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "payplug"
  s.summary = "Insert Payplug summary."
  s.description = "Insert Payplug description."
  s.files = Dir["{app,config,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.1"
  s.add_development_dependency "rspec-rails", "~> 2.5"
  s.add_development_dependency "capybara"
end
