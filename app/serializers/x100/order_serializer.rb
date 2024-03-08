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
  class OrderSerializer < ActiveModel::Serializer
    attributes :id, :products, :amount, :serial, :ordered_at, :tickets, :TX_transaction, :currency, :player_id
    has_one :x100_client
    has_one :x100_raffle

    def player_id
      638
    end

    def currency
      X100::Ticket.where(position: object.products, x100_raffle_id: object.x100_raffle_id).first.money
    end

    def tickets
      X100::Ticket.where(position: object.products, x100_raffle_id: object.x100_raffle_id)
    end

    def TX_transaction
      "DEBIT"
    end
  end
end
