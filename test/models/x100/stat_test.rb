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
require "test_helper"

class X100::StatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
