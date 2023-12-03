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
module Shared
  class Transaction < ApplicationRecord
    belongs_to :shared_wallet, class_name: 'Shared::Wallet', foreign_key: 'shared_wallet_id'
  end
end
