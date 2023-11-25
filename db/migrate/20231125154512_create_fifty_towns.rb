class CreateFiftyTowns < ActiveRecord::Migration[7.0]
  def change
    create_table :fifty_towns do |t|
      t.string :municipio
      t.string :capital
      t.references :fifty_location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
