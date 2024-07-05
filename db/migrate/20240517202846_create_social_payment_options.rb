class CreateSocialPaymentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :social_payment_options do |t|
      t.string :name
      t.jsonb :details
      t.string :country
      t.references :social_influencer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
