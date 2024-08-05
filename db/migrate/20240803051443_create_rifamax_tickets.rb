class CreateRifamaxTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :rifamax_tickets do |t|
      t.string :sign
      t.integer :number
      t.integer :number_position
      t.string :uniq_identifier_serial
      t.boolean :is_sold
      t.boolean :is_winner
      t.references :raffle, null: false, foreign_key: { to_table: :rifamax_raffles }

      t.timestamps
    end
  end
end
