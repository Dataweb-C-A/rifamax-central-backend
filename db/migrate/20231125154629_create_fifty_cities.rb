class CreateFiftyCities < ActiveRecord::Migration[7.0]
  def change
    create_table :fifty_cities do |t|
      t.string :ciudad
      t.references :fifty_location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
