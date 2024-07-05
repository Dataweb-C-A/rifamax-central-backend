class AddSharedExchangeToSocialPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    add_reference :social_payment_methods, :shared_exchange, null: true, foreign_key: true
  end
end
