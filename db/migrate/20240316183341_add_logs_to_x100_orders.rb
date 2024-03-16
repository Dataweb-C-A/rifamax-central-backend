class AddLogsToX100Orders < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_orders, :logs, :jsonb, array: true, default: []
  end
end
