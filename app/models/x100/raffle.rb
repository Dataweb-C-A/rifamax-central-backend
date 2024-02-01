# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_raffles
#
#  id                      :bigint           not null, primary key
#  ad                      :string
#  automatic_taquillas_ids :integer          default([]), is an Array
#  combos                  :jsonb
#  draw_type               :string
#  expired_date            :datetime
#  has_winners             :boolean
#  init_date               :datetime
#  limit                   :integer
#  lotery                  :string
#  money                   :string
#  numbers                 :integer
#  price_unit              :float
#  prizes                  :jsonb
#  raffle_type             :string
#  status                  :string
#  tickets_count           :integer
#  title                   :string
#  winners                 :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  shared_user_id          :integer          not null
#
module X100
  class Raffle < ApplicationRecord
    mount_uploader :ad, X100::AdUploader
    has_many :x100_tickets, class_name: 'X100::Ticket', foreign_key: 'x100_raffle_id', dependent: :destroy
    has_one :x100_stat, class_name: 'X100::Stat', foreign_key: 'x100_raffle_id', dependent: :destroy
    has_many :x100_orders, class_name: 'X100::Order', foreign_key: 'x100_raffle_id', dependent: :destroy

    after_create :generate_tickets
    after_create :initialize_status
    after_create :initialize_winners
    after_commit :when_raffle_expires

    validates :title,
              presence: true,
              length: {
                minimum: 5
              }

    validates :numbers,
              presence: true,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 999
              }

    validates :price_unit,
              presence: true,
              numericality: {
                greater_than_or_equal_to: 0.1
              }

    validates :limit,
              presence: true,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 100
              },
              if: -> { draw_type == 'Progresiva' }

    validates :lotery,
              presence: true

    validates :expired_date,
              presence: true,
              if: -> { draw_type == 'Fecha limite' }

    validates :init_date,
              presence: true

    validates :draw_type,
              presence: true

    validates :money,
              presence: true,
              inclusion: { in: %w[Bs.D $ COP] }

    validates :tickets_count,
              presence: true,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 100,
                less_than_or_equal_to: 1000
              },
              if: -> { raffle_type != 'Infinito' }

    validates :shared_user_id,
              presence: true,
              numericality: {
                only_integer: true
              }

    validates :raffle_type,
              presence: true,
              inclusion: { in: %w[Infinito Terminal Triple] }

    validate :validates_prizes_structure

    validate :validates_winners_structure

    validate :validates_combos_structure

    validate :validates_draw_types

    validate :validates_shared_user

    validate :validates_automatic_taquillas

    def self.raffles_by_user(user)
      case user.role
      when 'Rifero'
        X100::Raffle.where(shared_user_id: user.id).reject { |item| item.status == 'Cerrada' }
      when 'Taquilla'
        X100::Raffle.where(shared_user_id: user.rifero_ids << user.id).reject { |item| item.status == 'Cerrada' }
      when 'Admin'
        X100::Raffle.select { |item| item.status == 'En venta' }
      end
    end

    def self.active_raffles_for_user(user)
      if user.role == 'Admin'
        where(status: 'En venta')
      elsif user.role == 'Taquilla'
        where(id: [user.id, user.rifero_ids], status: 'En venta')
      else
        where(id: user.id, status: 'En venta')
      end.order(id: :desc)
    end

    def which(search = [], status = 'available')
      results = {}

      results[:tickets] = handle_tickets_search(status) if search.include?('tickets')
      results[:raffle] = self if search.include?('raffle')
      results[:winners] = handle_winners_search if search.include?('winners')
      results[:stats] = handle_stats_search if search.include?('stats')

      results.empty? ? { message: "Provide valid search params: ['tickets', 'raffle', 'winners', 'stats']" } : results
    end

    def tickets
      @tickets ||= JSON.parse($redis.get("x100_raffle_tickets:#{id}"))
    end

    def tickets_sold
      x100_tickets
    end

    private

    def initialize_status
      self.status = 'En venta'
      save
    end

    def initialize_winners
      self.has_winners = false
      save
    end

    def when_raffle_expires
      return unless status == 'Cerrada'

      $redis.expire("x100_raffle_tickets:#{id}", 259_200)

      X100::Stat.create(
        x100_raffle_id: id,
        tickets_sold: tickets_sould.count,
        profit: tickets_sold.count * price_unit
      )

      @raffles = X100::Raffle.all

      ActionCable.server.broadcast('x100_raffles', @raffles)
    end

    def generate_tickets
      tickets = []

      tickets_count.times do |position|
        tickets << {
          position: position + 1,
          price: nil,
          money: nil,
          x100_raffle_id: id,
          x100_client_id: nil,
          serial: SecureRandom.uuid
        }
      end

      X100::Ticket.insert_all(tickets)
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

    def self.current_progress_of_actives
      raffles = X100::Raffle.where(status: 'En venta').order(id: :desc)
      progresses = []

      raffles.each do |raffle|
        progress = case raffle.tickets_count
                   when 100
                     raffle.x100_tickets.where(status: 'sold').count
                   when 1000
                     ((raffle.x100_tickets.where(status: 'sold').count.to_f / raffle.tickets_count) * 100).round(2)
                   else
                     100
                   end

        progresses << { raffle_id: raffle.id, progress: }
      end

      progresses
    end

    def handle_tickets_search(status)
      case status
      when 'available'
        parse_raffle_tickets
      when 'sold'
        sold_tickets
      end
    end

    def parse_raffle_tickets
      JSON.parse($redis.get("x100_raffle_tickets:#{id}"))
    end

    def sold_tickets
      tickets.select { |item| item['is_sold'] == true }
    end

    def handle_winners_search
      winners.nil? ? { message: 'No winners yet' } : winners
    end

    def handle_stats_search
      x100_stat.nil? ? { message: 'No stats yet' } : x100_stat
    end

    def validates_winners_structure
      return if winners.nil?
      return unless winners.length.positive?

      winners.each do |winner|
        errors.add(:winners, 'Debe agregar un nombre al ganador') if winner[:name].nil?

        errors.add(:winners, 'Debe agregar un telefono al ganador') if winner[:phone].nil?

        errors.add(:winners, 'Debe agregar un dni al ganador') if winner[:dni].nil?

        errors.add(:winners, 'Debe agregar una posicion al ganador') if winner[:prize_position].nil?

        errors.add(:winners, 'Debe agregar un ticket al ganador') if winner[:ticket_winner].nil?
      end
    end

    def validates_prizes_structure
      if prizes.nil?
        errors.add(:prizes, 'Debe agregar al menos un premio')
      else
        errors.add(:prizes, 'Debe agregar al menos un premio') if prizes.empty?

        prizes.each do |prize|
          errors.add(:prizes, 'Debe agregar un nombre al premio') if prize['name'].nil?

          errors.add(:prizes, 'Debe agregar una posicion al premio') if prize['prize_position'].nil?
        end
      end
    end

    def validates_combos_structure
      return if combos.nil?
      return unless combos.length.positive?

      combos.each do |combo|
        errors.add(:combos, 'Debe agregar la cantidad de ticket del combo') if combo['quantity'].nil?
        errors.add(:combos, 'Debe agregar el precio del combo') if combo['price'].nil?
      end
    end

    def validates_draw_types
      allowed_draw_types = ['Progresiva', 'Fecha limite', 'Infinito']

      return unless allowed_draw_types.include?(draw_type) == false

      errors.add(:draw_type, 'Tipo de rifa no permitido')
    end

    def validates_automatic_taquillas
      return unless automatic_taquillas_ids.length.positive?

      automatic_taquillas_ids.each do |taquilla_id|
        if Shared::User.find(taquilla_id).role != 'Taquilla'
          errors.add(:automatic_taquillas_ids, 'El usuario no es una taquilla')
        end
      end
    end

    def validates_shared_user
      return unless Shared::User.find(shared_user_id).role != 'Taquilla'

      errors.add(:shared_user_id, 'El usuario no es una taquilla')
    end

    def sell_tickets; end
  end
end
