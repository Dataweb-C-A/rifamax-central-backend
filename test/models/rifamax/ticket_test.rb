# == Schema Information
#
# Table name: rifamax_tickets
#
#  id                     :bigint           not null, primary key
#  is_sold                :boolean
#  is_winner              :boolean
#  number                 :integer
#  number_position        :integer
#  sign                   :string
#  uniq_identifier_serial :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  raffle_id              :bigint           not null
#
# Indexes
#
#  index_rifamax_tickets_on_raffle_id  (raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (raffle_id => rifamax_raffles.id)
#
require "test_helper"

class Rifamax::TicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
