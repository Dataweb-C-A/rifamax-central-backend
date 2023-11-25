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
require "test_helper"

class Fifty::TownTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
