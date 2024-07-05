class AddSocialInfluencerToSocialPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    add_reference :social_payment_methods, :social_influencer, foreign_key: true
  end
end
