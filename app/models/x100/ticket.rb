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

    after_update :schedule_progressive_ending
    # after_create :generate_order

    aasm column: 'status' do
      state :available, initial: true
      state :reserved
      state :sold
      state :winner

      event :apart do
        transitions from: :available, to: :reserved
      end

      event :sell do
        transitions from: :reserved, to: :sold
      end

      event :turn_available do
        transitions from: :reserved, to: :available
      end

      event :turn_winner do
        transitions from: :sold, to: :winner
      end
    end

    def self.all_sold_tickets
      raffles = X100::Raffle.where(status: ['En venta', 'Finalizando'])

      result = []

      raffles.each do |raffle|
        result << {
          raffle_id: raffle.id,
          sold: raffle.x100_tickets.where(status: 'sold').map(&:position).flatten,
          reserved: raffle.x100_tickets.where(status: 'reserved').map(&:position).flatten,
          winners: raffle.x100_tickets.where(status: 'winner').map(&:position).flatten
        }
      end

      result
    end

    def self.all_reserved_tickets
      raffles = X100::Raffle.where(status: ['En venta', 'Finalizando'])

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
        ticket.apart!
        $redis.setex("ticket_#{ticket.id}", 300, ticket.id)
      end
    end

    def self.apart_ticket_integrator(id, integrator_id, integrator_type, money)
      client = X100::Client.find_by(integrator_id: integrator_id, integrator_type: integrator_type)
      url = ENV["#{integrator_type.to_s.downcase!}_url_base"]
      currency = money.to_s.upcase!

      ActiveRecord::Base.transaction do
        ticket = X100::Ticket.lock('FOR UPDATE NOWAIT').find(id)
        case integrator_type
        when 'CDA'
          res = HTTParty.get("#{url}/wallets_rifas?player_id=#{integrator_id}&currency=#{currency}")
          
          if res.code == 200
            if currency == 'USD'
              if (res.data.balance.to_f < (ticket.x100_raffle.price_unit))
                raise ActiveRecord::Rollback, 'Insufficient funds'
              end
            elsif currency == 'COP'
              if (res.data.balance.to_f < (ticket.x100_raffle.price_unit * Shared::Exchange.last.value_cop))
                raise ActiveRecord::Rollback, 'Insufficient funds'
              end
            else
              if (res.data.balance.to_f < (ticket.x100_raffle.price_unit * Shared::Exchange.last.value_bs))
                raise ActiveRecord::Rollback, 'Insufficient funds'
              end
            end
          else
            raise ActiveRecord::Rollback, "Integrator Job is down or not responding, integrator: #{integrator_type}"
          end
        else
          raise ActiveRecord::Rollback, 'Integrator Type is not defined'
        end
        ticket.x100_client_id = client.id
        ticket.apart!
        ticket.save!
        $redis.setex("ticket_#{ticket.id}", 300, ticket.id)
        return { message: 'Ticket aparted successfully', ticket: ticket }
      end
    end

    def self.make_available(id)
      ActiveRecord::Base.transaction do
        ticket = X100::Ticket.lock('FOR UPDATE NOWAIT').find(id)
        ticket.turn_available!
        ticket.x100_client_id = nil
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

    def self.refresh
      url = 'https://api.rifa-max.com/x100/tickets/refresh'

      HTTParty.post(url)
    end

    # def schedule_ending
    #   raffle = self.x100_raffle
    #   tickets = X100::Ticket.find_by(x100_raffle_id: self.x100_raffle.id, status: 'sold').count
    #   return unless tickets

    #   if raffle.draw_type == 'Progresiva'
    #     case raffle.tickets_count
    #     when 100
    #       if (tickets <= raffle.limit && raffle.status == 'Finalizando')
    #         $redis.setex('path:awards_#{raffle.id}', 604800, raffle.id)
    #       end
    #     when 1000
    #       if (((tickets.count.to_f / 1000) * 100).round(2) >= 100 && raffle.status == 'Finalizando')
    #         $redis.setex('path:awards_#{raffle.id}', 604800, raffle.id)
    #       end
    #     else
    #       0
    #     end
    #   else
    #     0
    #   end
    # end

    def schedule_progressive_ending
      raffle = x100_raffle
      return 'No se ha definido el tipo de sorteo' unless raffle.draw_type == 'Progresiva'

      prizes_days_sum = raffle.prizes.sum { |prize| prize['days_to_award'] }
      sold_tickets_percentage = (raffle.x100_tickets.where(status: 'sold').count.to_f / raffle.tickets_count) * 100

      if sold_tickets_percentage.round(2) >= raffle.limit
        raffle.update(status: 'Finalizando', expired_date: DateTime.now + prizes_days_sum.days)
        $redis.setex("select:winner_#{raffle.id}", 43_400, raffle.id)
      end

      schedule_prizes_awards(raffle) unless raffle.expired_date.nil?
    end

    private

    def schedule_prizes_awards(raffle)
      raffle.prizes.each do |prize|
        prize_day = prize['days_to_award']

        if prize_day != 0 && raffle.status != 'Cerrado'
          $redis.setex("path:awards_#{raffle.id}", prize_day * 86_400, raffle.id)
        end

        if prize_day == 0 && raffle.status != 'Cerrado' && raffle.draw_type == 'Fecha limite'
          $redis.setex("path:awards_#{raffle.id}", 60, raffle.id)
        end
      end
    end

    # def self.generate_order(positions)
    #   order = X100::Order.new(
    #     products: positions,
    #     amount: price,
    #     serial: 'ORD-#{SecureRandom.hex(8).upcase}',
    #     ordered_at: DateTime.now,
    #     shared_user_id: x100_raffle.shared_user_id,
    #     x100_client_id: x100_client_id,
    #     x100_raffle_id: x100_raffle.id
    #   )

    #   if order.save
    #     puts 'saved'
    #   else
    #     puts order.errors.full_messages
    #   end
    # end
  end
end
