# == Schema Information
#
# Table name: social_orders
#
#  id                       :bigint           not null, primary key
#  amount                   :float
#  money                    :string
#  ordered_at               :datetime
#  products                 :integer
#  serial                   :string
#  status                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  shared_exchange_id       :bigint           not null
#  social_client_id         :bigint           not null
#  social_payment_method_id :bigint           not null
#  social_raffle_id         :bigint           not null
#
# Indexes
#
#  index_social_orders_on_shared_exchange_id        (shared_exchange_id)
#  index_social_orders_on_social_client_id          (social_client_id)
#  index_social_orders_on_social_payment_method_id  (social_payment_method_id)
#  index_social_orders_on_social_raffle_id          (social_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_exchange_id => shared_exchanges.id)
#  fk_rails_...  (social_client_id => social_clients.id)
#  fk_rails_...  (social_payment_method_id => social_payment_methods.id)
#  fk_rails_...  (social_raffle_id => social_raffles.id)
#
class Social::Order < ApplicationRecord
  belongs_to :social_client, class_name: 'Social::Client', foreign_key: 'social_client_id'
  belongs_to :social_raffle, class_name: 'Social::Raffle', foreign_key: 'social_raffle_id'
  belongs_to :shared_exchange, class_name: 'Shared::Exchange', foreign_key: 'shared_exchange_id'
  belongs_to :social_payment_method, class_name: 'Social::PaymentMethod', foreign_key: 'social_payment_method_id'
end
