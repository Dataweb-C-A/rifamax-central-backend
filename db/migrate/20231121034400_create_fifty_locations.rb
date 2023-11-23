class CreateFiftyLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :fifty_locations do |t|
      t.string :country
      t.string :state

      t.timestamps
    end
  end
end
