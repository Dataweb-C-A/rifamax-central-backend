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
class X100::Order < ApplicationRecord
  belongs_to :shared_user, class_name: 'Shared::User', foreign_key: 'shared_user_id'
  belongs_to :x100_client, class_name: 'X100::Client', foreign_key: 'x100_client_id'
end
