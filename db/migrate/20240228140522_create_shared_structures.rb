class CreateSharedStructures < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_structures do |t|
      t.string :name
      t.string :token, default: "rm_live_#{SecureRandom.uuid}"
      t.string :access_to, array: true, default: []
      t.references :shared_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
