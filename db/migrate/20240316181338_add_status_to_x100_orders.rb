class AddStatusToX100Orders < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_orders, :status, :string, default: 'active'
  end
end
