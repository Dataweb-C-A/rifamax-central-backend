# == Schema Information
#
# Table name: dev_feature_flags
#
#  id          :bigint           not null, primary key
#  description :string
#  enabled     :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_dev_feature_flags_on_name  (name) UNIQUE
#
require "test_helper"

class Dev::FeatureFlagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
