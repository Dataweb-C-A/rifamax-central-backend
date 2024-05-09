class AddUsernameToX100Clients < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_clients, :username, :string
  end
end
