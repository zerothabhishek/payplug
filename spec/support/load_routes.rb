RSpec.configure do |c| 
  c.include Payplug::Engine.routes.url_helpers, :example_group => {
    :file_path => /\bspec\/integration\//
  }
end