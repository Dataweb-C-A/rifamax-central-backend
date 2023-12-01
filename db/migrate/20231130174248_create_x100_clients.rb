class CreateX100Clients < ActiveRecord::Migration[7.0]
  def change
    create_table :x100_clients do |t|
      t.string :name
      t.string :dni
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
