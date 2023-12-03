# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_exchanges
#
#  id               :bigint           not null, primary key
#  automatic        :boolean
#  mainstream_money :string
#  value_bs         :float
#  value_cop        :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

module Shared
  class ExchangeTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
