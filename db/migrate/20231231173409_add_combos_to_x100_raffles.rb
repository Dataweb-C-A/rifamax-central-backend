class AddCombosToX100Raffles < ActiveRecord::Migration[7.0]
  def change
    add_column :x100_raffles, :combos, :jsonb
  end
end
