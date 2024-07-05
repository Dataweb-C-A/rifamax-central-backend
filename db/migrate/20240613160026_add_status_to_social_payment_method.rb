class AddStatusToSocialPaymentMethod < ActiveRecord::Migration[7.0]
  def change
    add_column :social_payment_methods, :status, :string, default: "active"
  end
end
