class AddIntegratorToX100Orders < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_orders, :integrator_player_id, :integer
    add_column :x100_orders, :integrator, :string
  end
end
