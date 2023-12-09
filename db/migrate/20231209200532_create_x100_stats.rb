class CreateX100Stats < ActiveRecord::Migration[7.0]
  def change
    create_table :x100_stats do |t|
      t.integer :tickets_sold
      t.float :profit
      t.references :x100_raffle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
