class AddExchangesToSocialPaymentMethod < ActiveRecord::Migration[7.0]
  def change
    add_column :social_payment_methods, :amount, :float
    add_column :social_payment_methods, :currency, :string
  end
end
