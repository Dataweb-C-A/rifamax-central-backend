# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_orders
#
#  id                   :bigint           not null, primary key
#  amount               :float
#  integrator           :string
#  logs                 :jsonb            is an Array
#  money                :string
#  ordered_at           :datetime
#  products             :integer          default([]), is an Array
#  serial               :string
#  status               :string           default("active")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  integrator_player_id :integer
#  shared_exchange_id   :bigint           not null
#  shared_user_id       :bigint           not null
#  x100_client_id       :bigint           not null
#  x100_raffle_id       :bigint           not null
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
require 'test_helper'

module X100
  class OrderTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
