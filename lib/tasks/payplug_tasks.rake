
namespace :payplug do
  
  desc "generate the database migrations for payplug"
  task :migrate do
    `rails generate migration PayplugMigration`
  end
  
end
