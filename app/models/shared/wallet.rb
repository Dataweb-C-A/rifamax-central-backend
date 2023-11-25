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
class Shared::Wallet < ApplicationRecord
  belongs_to :shared_user, class_name: 'Shared::User', foreign_key: 'shared_user_id'
  has_many :shared_transactions, class_name: 'Shared::Transaction', foreign_key: 'share_wallet_id'
end
