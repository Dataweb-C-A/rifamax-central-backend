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
class Social::Badge < ApplicationRecord
  belongs_to :social_influencer, class_name: 'Social::Influencer', foreign_key: 'social_influencer_id'
end
