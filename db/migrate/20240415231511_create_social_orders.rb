class CreateSocialOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :social_orders do |t|
      t.float :amount
      t.string :money
      t.datetime :ordered_at
      t.integer :products
      t.string :serial
      t.string :status
      t.references :social_client, null: false, foreign_key: true
      t.references :social_raffle, null: false, foreign_key: true
      t.references :shared_exchange, null: false, foreign_key: true
      t.references :social_payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
