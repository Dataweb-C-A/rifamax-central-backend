# frozen_string_literal: true

class CreateSharedExchanges < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_exchanges do |t|
      t.boolean :automatic
      t.float :value_bs
      t.float :value_cop
      t.string :mainstream_money

      t.timestamps
    end
  end
end
