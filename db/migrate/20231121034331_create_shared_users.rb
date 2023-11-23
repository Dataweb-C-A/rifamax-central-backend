class CreateSharedUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_users do |t|
      t.string :avatar
      t.string :name
      t.string :role
      t.string :dni
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :slug
      t.boolean :is_active
      t.integer :rifero_ids, array: true, default: []
      t.integer :module_assigned, array: true, default: []

      t.timestamps
    end
  end
end
