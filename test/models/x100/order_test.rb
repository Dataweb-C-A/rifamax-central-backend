# == Schema Information
#
# Table name: x100_orders
#
#  id             :bigint           not null, primary key
#  amount         :float
#  ordered_at     :datetime
#  products       :integer          default([]), is an Array
#  serial         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shared_user_id :bigint           not null
#  x100_client_id :bigint           not null
#  x100_raffle_id :bigint           not null
#
# Indexes
#
#  index_x100_orders_on_shared_user_id  (shared_user_id)
#  index_x100_orders_on_x100_client_id  (x100_client_id)
#  index_x100_orders_on_x100_raffle_id  (x100_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_user_id => shared_users.id)
#  fk_rails_...  (x100_client_id => x100_clients.id)
#  fk_rails_...  (x100_raffle_id => x100_raffles.id)
#
require "test_helper"

class X100::OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
