# frozen_string_literal: true

class CreateFiftyLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :fifty_locations do |t|
      t.string :iso_31662
      t.string :estado
      t.string :capital
      t.integer :id_estado

      t.timestamps
    end
  end
end
