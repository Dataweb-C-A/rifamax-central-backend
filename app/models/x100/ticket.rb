# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_tickets
#
#  id             :bigint           not null, primary key
#  is_sold        :boolean
#  money          :string
#  perform_at     :integer
#  positions      :integer          not null, is an Array
#  price          :float
#  serial         :string
#  ticket_number  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  x100_client_id :bigint           not null
#  x100_raffle_id :bigint           not null
#
# Indexes
#
#  index_x100_tickets_on_x100_client_id  (x100_client_id)
#  index_x100_tickets_on_x100_raffle_id  (x100_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (x100_client_id => x100_clients.id)
#  fk_rails_...  (x100_raffle_id => x100_raffles.id)
#
module X100
  class Ticket < ApplicationRecord
    belongs_to :x100_raffle, class_name: 'X100::Raffle', foreign_key: 'x100_raffle_id'
    belongs_to :x100_client, class_name: 'X100::Client', foreign_key: 'x100_client_id'

    def self.all_sold_tickets
      raffles = X100::Raffle.all

      result = []

      raffles.each do |raffle|
        result << {
          raffle_id: raffle.id,
          positions: raffle.tickets_sold.select { |item| item.x100_raffle_id === raffle.id }.map(&:position)
        }
      end

      return result
    end

    def self.sold_tickets(raffle_id)
      raffles = X100::Raffle.where(id: raffle_id)

      result = []

      raffles.each do |raffle|
        result << {
          raffle_id: raffle.id,
          positions: raffle.tickets_sold.select { |item| item.x100_raffle_id === raffle.id }.map(&:position)
        }
      end

      return result
    end
  end
end
