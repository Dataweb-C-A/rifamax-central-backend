# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_transactions
#
#  id               :bigint           not null, primary key
#  amount           :float
#  transaction_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shared_wallet_id :bigint           not null
#
# Indexes
#
#  index_shared_transactions_on_shared_wallet_id  (shared_wallet_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_wallet_id => shared_wallets.id)
#
require 'test_helper'

module Shared
  class TransactionTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
