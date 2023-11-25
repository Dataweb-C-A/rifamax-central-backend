class CreateFiftyStadia < ActiveRecord::Migration[7.0]
  def change
    create_table :fifty_stadia do |t|
      t.string :name
      t.integer :fifty_location, null: false

      t.timestamps
    end
  end
end
