class CreateSocialRaffles < ActiveRecord::Migration[7.0]
  def change
    create_table :social_raffles do |t|
      t.string :ad
      t.jsonb :combos
      t.string :raffle_type
      t.boolean :has_winners
      t.datetime :init_date
      t.datetime :expired_date
      t.float :price_unit
      t.string :draw_type
      t.integer :tickets_count
      t.string :status
      t.string :title
      t.jsonb :winners
      t.jsonb :prizes
      t.string :money
      t.integer :limit
      t.references :social_influencer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
