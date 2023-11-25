# == Schema Information
#
# Table name: fifty_churches
#
#  id            :bigint           not null, primary key
#  parroquia     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fifty_town_id :bigint           not null
#
# Indexes
#
#  index_fifty_churches_on_fifty_town_id  (fifty_town_id)
#
# Foreign Keys
#
#  fk_rails_...  (fifty_town_id => fifty_towns.id)
#
class Fifty::Church < ApplicationRecord
  belongs_to :fifty_town, class_name: 'Fifty::Town', foreign_key: 'fifty_town_id'
end
