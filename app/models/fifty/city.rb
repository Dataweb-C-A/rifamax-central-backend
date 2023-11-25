# == Schema Information
#
# Table name: fifty_cities
#
#  id                :bigint           not null, primary key
#  ciudad            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  fifty_location_id :bigint           not null
#
# Indexes
#
#  index_fifty_cities_on_fifty_location_id  (fifty_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (fifty_location_id => fifty_locations.id)
#
class Fifty::City < ApplicationRecord
  belongs_to :fifty_location, class_name: 'Fifty::Location', foreign_key: 'fifty_location_id'
end
