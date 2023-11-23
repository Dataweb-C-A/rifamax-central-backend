class CreateRifamaxRaffles < ActiveRecord::Migration[7.0]
  def change
    create_table :rifamax_raffles do |t|
      t.date :init_date
      t.string :award_sign
      t.string :award_no_sign
      t.string :plate
      t.integer :year
      t.string :game, default: 'Zodiac'
      t.float :price
      t.string :loteria
      t.integer :numbers
      t.string :serial
      t.date :expired_date
      t.boolean :is_send
      t.boolean :is_closed
      t.boolean :refund
      # Relationships
      t.integer :rifero_id
      t.integer :taquilla_id
      t.integer :payment_id

      t.timestamps
    end
  end
end
