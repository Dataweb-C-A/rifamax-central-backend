# == Schema Information
#
# Table name: fifty_locations
#
#  id         :bigint           not null, primary key
#  country    :string
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class Fifty::LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
