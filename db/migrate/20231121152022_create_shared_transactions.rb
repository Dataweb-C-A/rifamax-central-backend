# frozen_string_literal: true

class CreateSharedTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_transactions do |t|
      t.string :transaction_type
      t.references :shared_wallet, null: false, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
