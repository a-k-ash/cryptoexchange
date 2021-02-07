class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.decimal :price, precision: 8, scale: 2
      t.decimal :volume, precision: 8, scale: 2
      t.decimal :traded_volume, precision: 8, scale: 2, default: 0.0
      t.integer :status, default: 1
      t.integer :side
      t.timestamps
    end
  end
end
