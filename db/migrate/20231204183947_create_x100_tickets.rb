# frozen_string_literal: true

class CreateX100Tickets < ActiveRecord::Migration[7.0]
  def change
    create_table :x100_tickets do |t|
      t.integer :position, null: true
      t.string :serial
      t.float :price
      t.string :money
      t.string :status, default: 'available'
      t.references :x100_raffle, null: false, foreign_key: true
      t.references :x100_client, null: true, foreign_key: true

      t.timestamps
    end
  end
end
