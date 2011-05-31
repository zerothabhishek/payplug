module Payplug
  class Engine < Rails::Engine
    isolate_namespace Payplug
    
    config.autoload_paths << File.expand_path("../", __FILE__)
    config.autoload_paths << File.expand_path("../../payplug.rb", __FILE__) 
    
    initializer 'payplug.init', :after=> :disable_dependency_loading do # => check http://www.cowboycoded.com/2010/08/02/hooking-in-your-rails-3-engine-or-railtie-initializer-in-the-right-place/ for the :after choice
      require "#{Rails.root}/config/payplug"
    end
    
  end
end
  