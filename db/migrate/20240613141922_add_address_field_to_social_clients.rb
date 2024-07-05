class AddAddressFieldToSocialClients < ActiveRecord::Migration[7.0]
  def change
    add_column :social_clients, :address, :string
  end
end
