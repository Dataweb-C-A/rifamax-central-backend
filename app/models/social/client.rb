# == Schema Information
#
# Table name: social_clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Social::Client < ApplicationRecord
  has_many :social_payment_methods, class_name: 'Social::PaymentMethod', foreign_key: 'social_client_id', dependent: :destroy
  has_many :social_orders, class_name: 'Social::Order', foreign_key: 'social_client_id', dependent: :destroy

  def methods
    social_payment_methods
  end
end
