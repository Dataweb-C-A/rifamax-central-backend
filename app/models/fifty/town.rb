# == Schema Information
#
# Table name: fifty_towns
#
#  id                :bigint           not null, primary key
#  capital           :string
#  municipio         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  fifty_location_id :bigint           not null
#
# Indexes
#
#  index_fifty_towns_on_fifty_location_id  (fifty_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (fifty_location_id => fifty_locations.id)
#
class Fifty::Town < ApplicationRecord
  belongs_to :fifty_location, class_name: 'Fifty::Location', foreign_key: 'fifty_location_id'
  has_many :fifty_churches, class_name: 'Fifty::Church', foreign_key: 'fifty_town_id'
end
