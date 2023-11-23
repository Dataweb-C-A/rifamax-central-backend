class CreateSharedWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_wallets do |t|
      t.string :token, default: SecureRandom.uuid
      t.float :found, default: 0.0
      t.float :debt, default: 0.0
      t.float :debt_limit, default: 20.0
      t.references :shared_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
