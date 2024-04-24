# == Schema Information
#
# Table name: dev_processes
#
#  id                 :bigint           not null, primary key
#  color              :string
#  content            :string
#  priority           :string
#  process_actives_at :datetime
#  process_type       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "test_helper"

class Dev::ProcessTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
