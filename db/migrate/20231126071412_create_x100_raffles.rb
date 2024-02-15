# frozen_string_literal: true

class CreateX100Raffles < ActiveRecord::Migration[7.0]
  def change
    create_table :x100_raffles do |t|
      t.string :ad
      t.string :title
      t.string :draw_type
      t.string :status
      t.integer :limit
      t.string :money
      t.string :raffle_type
      t.float :price_unit
      t.integer :tickets_count
      t.string :lotery
      t.datetime :expired_date
      t.datetime :init_date
      t.jsonb :prizes
      t.jsonb :winners
      t.jsonb :combos
      t.boolean :has_winners
      t.integer :automatic_taquillas_ids, array: true, default: []
      t.integer :shared_user_id, null: false

      t.timestamps
    end
  end
end
