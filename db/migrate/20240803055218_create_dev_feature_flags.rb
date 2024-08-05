class CreateDevFeatureFlags < ActiveRecord::Migration[7.0]
  def change
    create_table :dev_feature_flags do |t|
      t.string :name
      t.string :description
      t.boolean :enabled

      t.timestamps
    end
    add_index :dev_feature_flags, :name, unique: true
  end
end
