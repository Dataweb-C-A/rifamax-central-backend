# == Schema Information
#
# Table name: shared_structures
#
#  id             :bigint           not null, primary key
#  access_to      :string           default([]), is an Array
#  name           :string
#  token          :string           default("rm_live_3d8bfbce-05b6-48df-9428-f7b50a0766d6")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shared_user_id :bigint           not null
#
# Indexes
#
#  index_shared_structures_on_shared_user_id  (shared_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_user_id => shared_users.id)
#
require "test_helper"

class Shared::StructureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
