class CreatePayplugNotifications < ActiveRecord::Migration
  def change
    create_table :payplug_notifications do |t|
      t.text :params
      t.string :gateway
      t.string :transaction_id
      t.string :notification_status, :default => ""
      
      t.timestamps
    end
  end
end
