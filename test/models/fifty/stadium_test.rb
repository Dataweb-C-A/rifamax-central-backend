# == Schema Information
#
# Table name: fifty_stadia
#
#  id             :bigint           not null, primary key
#  fifty_location :integer          not null
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "test_helper"

class Fifty::StadiumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
