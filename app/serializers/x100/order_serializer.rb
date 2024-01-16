# == Schema Information
#
# Table name: x100_orders
#
#  id             :bigint           not null, primary key
#  amount         :float
#  ordered_at     :datetime
#  products       :integer
#  serial         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shared_user_id :bigint           not null
#  x100_client_id :bigint           not null
#
# Indexes
#
#  index_x100_orders_on_shared_user_id  (shared_user_id)
#  index_x100_orders_on_x100_client_id  (x100_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_user_id => shared_users.id)
#  fk_rails_...  (x100_client_id => x100_clients.id)
#
class X100::OrderSerializer < ActiveModel::Serializer
  attributes :id, :products, :amount, :serial, :ordered_at
  has_one :shared_user
  has_one :x100_client
end
