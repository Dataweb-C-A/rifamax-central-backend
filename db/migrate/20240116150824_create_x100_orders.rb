class CreateX100Orders < ActiveRecord::Migration[7.0]
  def change
    create_table :x100_orders do |t|
      t.integer :products, array: true, default: []
      t.float :amount
      t.string :serial
      t.datetime :ordered_at
      t.references :shared_user, null: false, foreign_key: true
      t.references :x100_client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
