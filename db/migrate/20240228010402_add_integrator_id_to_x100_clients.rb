class AddIntegratorIdToX100Clients < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_clients, :integrator_id, :integer
    add_column :x100_clients, :integrator_type, :string
  end
end
