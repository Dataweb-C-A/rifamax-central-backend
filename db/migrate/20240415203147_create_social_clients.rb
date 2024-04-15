class CreateSocialClients < ActiveRecord::Migration[7.0]
  def change
    create_table :social_clients do |t|
      t.string :name
      t.string :phone
      t.string :dni
      t.string :email

      t.timestamps
    end
  end
end
