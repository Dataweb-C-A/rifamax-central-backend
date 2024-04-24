class CreateDevProcesses < ActiveRecord::Migration[7.0]
  def change
    create_table :dev_processes do |t|
      t.string :process_type
      t.string :content
      t.datetime :process_actives_at
      t.string :priority
      t.string :color

      t.timestamps
    end
  end
end
