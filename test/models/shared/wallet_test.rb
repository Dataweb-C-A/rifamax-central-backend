# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_wallets
#
#  id             :bigint           not null, primary key
#  debt           :float            default(0.0)
#  debt_limit     :float            default(20.0)
#  found          :float            default(0.0)
#  token          :string           default("a049d97d-1602-4cd8-b140-87b1c6d6a4e6")
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
require 'test_helper'

module Shared
  class WalletTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
