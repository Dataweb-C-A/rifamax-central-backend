# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_clients
#
#  id              :bigint           not null, primary key
#  dni             :string
#  email           :string
#  integrator_type :string
#  name            :string
#  phone           :string
#  pv              :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  integrator_id   :integer
#
require 'test_helper'

module X100
  class ClientTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
