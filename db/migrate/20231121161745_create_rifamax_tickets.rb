# frozen_string_literal: true

class CreateRifamaxTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :rifamax_tickets do |t|
      t.string :sign
      t.integer :number
      t.integer :ticket_nro
      t.string :serial
      t.boolean :is_sold, default: false
      t.references :rifamax_raffle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
