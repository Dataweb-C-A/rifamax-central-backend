class CreateRifamaxRaffles < ActiveRecord::Migration[7.0]
  def change
    create_table :rifamax_raffles do |t|
      t.string :title
      t.date :init_date
      t.date :expired_date
      t.jsonb :prizes, array: true, default: []
      t.float :price
      t.integer :numbers
      t.string :currency
      t.string :lotery
      t.string :sell_status
      t.string :admin_status
      t.string :uniq_identifier_serial
      t.references :user, null: false, foreign_key: { to_table: :shared_users }
      t.references :seller, null: false, foreign_key: { to_table: :shared_users }

      t.timestamps
    end
  end
end
