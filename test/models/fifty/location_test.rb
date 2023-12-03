# frozen_string_literal: true

# == Schema Information
#
# Table name: fifty_locations
#
#  id         :bigint           not null, primary key
#  capital    :string
#  estado     :string
#  id_estado  :integer
#  iso_31662  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

module Fifty
  class LocationTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
