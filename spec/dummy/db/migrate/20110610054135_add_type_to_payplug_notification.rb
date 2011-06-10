class AddTypeToPayplugNotification < ActiveRecord::Migration
  def change
    change_table :payplug_notifications do |t|
      t.string :type
      t.rename :notification_status, :status
    end
  end
end
