class AddAddressToSocialClients < ActiveRecord::Migration[7.0]
  def change
    add_column :social_clients, :country, :string
    add_column :social_clients, :province, :string
    add_column :social_clients, :zip_code, :string
    remove_column :social_clients, :dni
  end
end
