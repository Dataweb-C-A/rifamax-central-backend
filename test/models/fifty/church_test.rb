# frozen_string_literal: true

# == Schema Information
#
# Table name: fifty_churches
#
#  id            :bigint           not null, primary key
#  parroquia     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fifty_town_id :bigint           not null
#
# Indexes
#
#  index_fifty_churches_on_fifty_town_id  (fifty_town_id)
#
# Foreign Keys
#
#  fk_rails_...  (fifty_town_id => fifty_towns.id)
#
require 'test_helper'

module Fifty
  class ChurchTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
