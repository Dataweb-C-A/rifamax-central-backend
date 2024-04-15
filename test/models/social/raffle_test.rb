# == Schema Information
#
# Table name: social_raffles
#
#  id                   :bigint           not null, primary key
#  ad                   :string
#  combos               :jsonb
#  draw_type            :string
#  expired_date         :datetime
#  has_winners          :boolean
#  init_date            :datetime
#  limit                :integer
#  money                :string
#  price_unit           :float
#  prizes               :jsonb
#  raffle_type          :string
#  status               :string
#  tickets_count        :integer
#  title                :string
#  winners              :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  social_influencer_id :bigint           not null
#
# Indexes
#
#  index_social_raffles_on_social_influencer_id  (social_influencer_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_influencer_id => social_influencers.id)
#
require "test_helper"

class Social::RaffleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
