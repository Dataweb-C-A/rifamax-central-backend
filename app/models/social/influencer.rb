# == Schema Information
#
# Table name: social_influencers
#
#  id             :bigint           not null, primary key
#  content_code   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shared_user_id :bigint           not null
#
# Indexes
#
#  index_social_influencers_on_shared_user_id  (shared_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_user_id => shared_users.id)
#
class Social::Influencer < ApplicationRecord
  belongs_to :shared_user, class_name: 'Shared::User', foreign_key: 'shared_user_id'
end
