# frozen_string_literal: true

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
require 'test_helper'

module Fifty
  class StadiumTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
