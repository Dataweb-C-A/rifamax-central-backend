# == Schema Information
#
# Table name: social_tickets
#
#  id               :bigint           not null, primary key
#  money            :string
#  position         :integer
#  price            :float
#  serial           :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  social_raffle_id :bigint           not null
#
# Indexes
#
#  index_social_tickets_on_social_raffle_id  (social_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_raffle_id => social_raffles.id)
#
require "test_helper"

class Social::TicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
