class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.boolean :status
      t.string :currency
      t.string :mode
      t.integer :amount
      t.datetime :purchased_at

      t.timestamps
    end
  end
end
