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
class Social::Network < ApplicationRecord
  belongs_to :social_influencer, class_name: 'Social::Influencer', foreign_key: 'social_influencer_id'
end
