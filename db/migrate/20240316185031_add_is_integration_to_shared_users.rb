class AddIsIntegrationToSharedUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :shared_users, :is_integration, :boolean, default: false
  end
end
