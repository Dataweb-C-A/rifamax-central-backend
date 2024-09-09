class AddDetailsToSharedStructures < ActiveRecord::Migration[7.0]
  def change
    add_column :shared_structures, :promotional, :string
    add_column :shared_structures, :known_as, :string
    add_column :shared_structures, :url_base, :string
    add_column :shared_structures, :user_path, :string
  end
end
