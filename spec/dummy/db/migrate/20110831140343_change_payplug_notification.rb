class ChangePayplugNotification < ActiveRecord::Migration
  def up
    remove_column :payplug_notifications, :params
    add_column :payplug_notifications, :raw_params, :text
  end

  def down
    add_column :payplug_notifications, :params
    remove_column :payplug_notifications, :raw_params
  end
end
