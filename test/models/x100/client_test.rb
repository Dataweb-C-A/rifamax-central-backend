# == Schema Information
#
# Table name: x100_clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class X100::ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
