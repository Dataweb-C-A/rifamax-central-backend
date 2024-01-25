# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_tickets
#
#  id             :bigint           not null, primary key
#  money          :string
#  position       :integer
#  price          :float
#  serial         :string           default("8211942d-2e22-48b5-ad9d-bbb38523f0c4")
#  status         :string           default("available")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  x100_client_id :bigint
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
    include AASM

    belongs_to :x100_raffle, class_name: 'X100::Raffle', foreign_key: 'x100_raffle_id'
    belongs_to :x100_client, class_name: 'X100::Client', foreign_key: 'x100_client_id', optional: true

    after_create :generate_order
    after_update :broadcast_tickets

    aasm column: 'status' do
      state :available, initial: true
      state :reserved
      state :sold

      event :apart do
        transitions from: :available, to: :reserved
      end

      event :sell do
        transitions from: :reserved, to: :sold
      end

      event :turn_available do
        transitions from: :reserved, to: :available
      end
    end

    def self.all_sold_tickets
      raffles = X100::Raffle.all

      result = []

      raffles.each do |raffle|
        result << {
          raffle_id: raffle.id,
          sold: raffle.x100_tickets.where(status: 'sold').map(&:position).flatten,
          reserved: raffle.x100_tickets.where(status: 'reserved').map(&:position).flatten
        }
      end

      result
    end

    def self.all_reserved_tickets
      raffles = X100::Raffle.all

      result = []

      raffles.each do |raffle|
        result << {
          raffle_id: raffle.id,
          positions: raffle.x100_tickets.where(status: 'reserved').map(&:position).flatten
        }
      end

      result
    end

    def self.apart_ticket(id)
      ActiveRecord::Base.transaction do
        ticket = X100::Ticket.lock('FOR UPDATE NOWAIT').find(id)
        X100::TicketsWorker.perform_at(1.minutes.from_now)
        ticket.apart!
        ticket.save!
      end
    end

    def self.make_available(id)
      ActiveRecord::Base.transaction do
        ticket = X100::Ticket.lock('FOR UPDATE NOWAIT').find(id)
        ticket.turn_available!
        ticket.save!
      end
    end
    
    def self.sell_ticket(id)
      ActiveRecord::Base.transaction do
        ticket = X100::Ticket.lock('FOR UPDATE NOWAIT').find(id)
        if ticket.status == 'reserved'
          ticket.sell!
          ticket.save!
        end
      end
    end

    def broadcast_tickets
      @tickets = X100::Ticket.all_sold_tickets
      ActionCable.server.broadcast('x100_tickets', @tickets)
    end

    def self.generate_order(positions)
      order = X100::Order.new(
        products: positions,
        amount: price,
        serial: "ORD-#{SecureRandom.hex(8).upcase}",
        ordered_at: DateTime.now,
        shared_user_id: x100_raffle.shared_user_id,
        x100_client_id:,
        x100_raffle_id:
      )

      if order.save
        puts 'saved'
      else
        puts order.errors.full_messages
      end
    end
  end
end
