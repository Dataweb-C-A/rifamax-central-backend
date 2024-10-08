class AddWelcomingToSharedUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :shared_users, :welcoming, :boolean, default: true
  end
end
