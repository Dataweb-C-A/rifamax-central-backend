# == Schema Information
#
# Table name: x100_tickets
#
#  id             :bigint           not null, primary key
#  is_sold        :boolean
#  position       :integer
#  serial         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  x100_client_id :bigint           not null
#  x100_raffle_id :bigint           not null
#
# Indexes
#
#  index_x100_tickets_on_x100_client_id  (x100_client_id)
#  index_x100_tickets_on_x100_raffle_id  (x100_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (x100_client_id => x100_clients.id)
#  fk_rails_...  (x100_raffle_id => x100_raffles.id)
#
class X100::Ticket < ApplicationRecord
  belongs_to :x100_raffle, class_name: 'X100::Raffle', foreign_key: 'x100_raffle_id'
  belongs_to :x100_client, class_name: 'X100::Client', foreign_key: 'x100_client_id'
end
