class CreateSocialPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :social_payment_methods do |t|
      t.string :payment
      t.jsonb :details
      t.references :social_client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
