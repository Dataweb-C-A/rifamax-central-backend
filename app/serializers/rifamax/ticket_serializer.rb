# frozen_string_literal: true

# == Schema Information
#
# Table name: rifamax_tickets
#
#  id                :bigint           not null, primary key
#  is_sold           :boolean          default(FALSE)
#  number            :integer
#  serial            :string
#  sign              :string
#  ticket_nro        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  rifamax_raffle_id :bigint           not null
#
# Indexes
#
#  index_rifamax_tickets_on_rifamax_raffle_id  (rifamax_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (rifamax_raffle_id => rifamax_raffles.id)
#
module Rifamax
  class TicketSerializer < ActiveModel::Serializer
    attributes :id
  end
end
