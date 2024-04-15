class CreateSocialTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :social_tickets do |t|
      t.string :money
      t.integer :position
      t.float :price
      t.string :serial
      t.string :status
      t.references :social_raffle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
