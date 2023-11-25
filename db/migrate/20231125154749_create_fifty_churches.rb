class CreateFiftyChurches < ActiveRecord::Migration[7.0]
  def change
    create_table :fifty_churches do |t|
      t.string :parroquia
      t.references :fifty_town, null: false, foreign_key: true

      t.timestamps
    end
  end
end
