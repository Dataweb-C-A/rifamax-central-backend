# == Schema Information
#
# Table name: social_networks
#
#  id                   :bigint           not null, primary key
#  name                 :string
#  url                  :string
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  social_influencer_id :bigint           not null
#
# Indexes
#
#  index_social_networks_on_social_influencer_id  (social_influencer_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_influencer_id => social_influencers.id)
#
require "test_helper"

class Social::NetworkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
