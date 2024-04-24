class AddPvToX100Clients < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_clients, :pv, :boolean, default: false
  end
end
