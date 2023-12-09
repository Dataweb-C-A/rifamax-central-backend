# == Schema Information
#
# Table name: x100_stats
#
#  id             :bigint           not null, primary key
#  profit         :float
#  tickets_sold   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  x100_raffle_id :bigint           not null
#
# Indexes
#
#  index_x100_stats_on_x100_raffle_id  (x100_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (x100_raffle_id => x100_raffles.id)
#
class X100::Stat < ApplicationRecord
  belongs_to :x100_raffle, class_name: 'X100::Raffle', foreign_key: 'x100_raffle_id'
end
