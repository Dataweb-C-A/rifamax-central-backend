# == Schema Information
#
# Table name: shared_wallets
#
#  id             :bigint           not null, primary key
#  debt           :float            default(0.0)
#  debt_limit     :float            default(20.0)
#  found          :float            default(0.0)
#  token          :string           default("31caaa0f-ac25-407c-8562-c3bf75aac60d")
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
  belongs_to :shared_user
  has_many :shared_transactions
end
