# == Schema Information
#
# Table name: shared_wallets
#
#  id             :bigint           not null, primary key
#  debt           :float            default(0.0)
#  debt_limit     :float            default(20.0)
#  found          :float            default(0.0)
#  token          :string           default("877c9e0a-e72a-47f1-a522-396d7c731c01")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shared_user_id :bigint           not null
#
# Indexes
#
#  index_shared_wallets_on_shared_user_id  (shared_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_user_id => shared_users.id)
#
require "test_helper"

class Shared::WalletTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
