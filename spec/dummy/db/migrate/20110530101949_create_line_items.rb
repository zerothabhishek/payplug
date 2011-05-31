class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :price
      t.string :xyz_name
      t.integer :order_id
      t.integer :qty
      t.string :discount_code

      t.timestamps
    end
  end
end
