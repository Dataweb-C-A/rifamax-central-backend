class AddIsFirstEntryToSharedUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :shared_users, :is_first_entry, :boolean, default: false
  end
end
