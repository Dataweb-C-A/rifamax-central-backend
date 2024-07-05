# == Schema Information
#
# Table name: social_badges
#
#  id                   :bigint           not null, primary key
#  color                :string
#  icon                 :string
#  title                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  social_influencer_id :bigint           not null
#
# Indexes
#
#  index_social_badges_on_social_influencer_id  (social_influencer_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_influencer_id => social_influencers.id)
#
require "test_helper"

class Social::BadgeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
