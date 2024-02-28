# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_orders
#
#  id                 :bigint           not null, primary key
#  amount             :float
#  money              :string
#  ordered_at         :datetime
#  products           :integer          default([]), is an Array
#  serial             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  shared_exchange_id :bigint           not null
#  shared_user_id     :bigint           not null
#  x100_client_id     :bigint           not null
#  x100_raffle_id     :bigint           not null
#
# Indexes
#
#  index_x100_orders_on_shared_exchange_id  (shared_exchange_id)
#  index_x100_orders_on_shared_user_id      (shared_user_id)
#  index_x100_orders_on_x100_client_id      (x100_client_id)
#  index_x100_orders_on_x100_raffle_id      (x100_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_exchange_id => shared_exchanges.id)
#  fk_rails_...  (shared_user_id => shared_users.id)
#  fk_rails_...  (x100_client_id => x100_clients.id)
#  fk_rails_...  (x100_raffle_id => x100_raffles.id)
#
module X100
  class Order < ApplicationRecord
    belongs_to :shared_user, class_name: 'Shared::User', foreign_key: 'shared_user_id'
    belongs_to :x100_client, class_name: 'X100::Client', foreign_key: 'x100_client_id'
    belongs_to :x100_raffle, class_name: 'X100::Raffle', foreign_key: 'x100_raffle_id'
    belongs_to :shared_exchange, class_name: 'Shared::Exchange', foreign_key: 'shared_exchange_id'
  
    validates :money,
              presence: true,
              inclusion: { in: %w[VES USD COP] }
  end
end
