class AddSocialRaffleToSocialPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    add_reference :social_payment_methods, :social_raffle, foreign_key: true
  end
end
