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
  class Raffle < ApplicationRecord # rubocop:disable Metrics/ClassLength
    self.table_name = 'x100_raffles'

    scope :active, -> { where(status: 'En venta') }
    scope :closing, -> { where(status: 'Finalizando') }
    scope :closed, -> { where(status: 'Cerrado') }

    mount_uploader :ad, X100::AdUploader
    has_many :x100_tickets, class_name: 'X100::Ticket', foreign_key: 'x100_raffle_id', dependent: :destroy
    has_one :x100_stat, class_name: 'X100::Stat', foreign_key: 'x100_raffle_id', dependent: :destroy
    has_many :x100_orders, class_name: 'X100::Order', foreign_key: 'x100_raffle_id', dependent: :destroy

    after_create :generate_tickets
    after_create :initialize_status
    after_create :initialize_winners
    after_create :initialize_raffle_type

    validates :title,
              presence: true,
              length: {
                minimum: 5
              }

    validates :price_unit,
              presence: true,
              numericality: {
                greater_than_or_equal_to: 0.1
              }

    validates :status,
              presence: true,
              inclusion: { in: ['En venta', 'Finalizando', 'Cerrado'] }

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
              inclusion: { in: %w[VES USD COP] }

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
      puts(user)
      X100::Raffle.where(status: ['En venta', 'Finalizando']).order(id: :desc)
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

    def self.active_raffles_progressive
      X100::Raffle.where(draw_type: 'Progresiva', status: ['En venta', 'Finalizando']).order(id: :desc)
    end

    def which(search = [], status = 'available')
      results = {}

      results[:tickets] = handle_tickets_search(status) if search.include?('tickets')
      results[:raffle] = self if search.include?('raffle')
      results[:winners] = handle_winners_search if search.include?('winners')
      results[:stats] = handle_stats_search if search.include?('stats')

      results.empty? ? { message: 'Provide valid search params: [tickets, raffle, winners, stats]' } : results
    end

    def tickets
      @tickets ||= JSON.parse($redis.get("x100_raffle_tickets:#{id}"))
    end

    def tickets_sold
      x100_tickets.where(status: 'sold').order(id: :asc)
    end

    def select_winner
      ActiveRecord::Base.transaction do
        raise 'No pueden haber más ganadores' if winners&.size == prizes.size

        case draw_type
        when 'Progresiva'
          select_progresive_winner
        when 'Fecha limite'
          select_date_limit_winner if expired_date.to_date <= Date.today
        else
          'Invalid draw type'
        end
      end
    end

    def select_combos(quantity)
      ActiveRecord::Base.transaction do
        validate_combos(quantity)

        @tickets = X100::Raffle.last.x100_tickets.available.sample(quantity.to_i)

        @result = []

        @tickets.each do |ticket|
          X100::Ticket.apart_ticket(ticket.id)
          ticket.status = 'reserved'
          @result << ticket
        end

        return @result
      end
    end

    private

    def validate_combos(quantity)
      raise 'Provides combos quantity value' if combos.blank?
      raise 'Insufficient tickets to select combo' if x100_tickets.count < quantity
      raise 'Raffle is closed, can buy' if status == 'Cerrado'

      combos_selected = nil

      combos.each do |combo|
        if combo['quantity'].to_i == quantity
          combos_selected = combo
        end
      end

      raise 'Invalid combo quantity' if combos_selected.nil?
    end

    def initialize_status
      self.status = 'En venta'
      save
    end

    def initialize_winners
      self.has_winners = false
      save
    end

    def initialize_raffle_type
      self.raffle_type = case tickets_count
                         when 100
                           'Terminal'
                         when 1000
                           'Triple'
                         else
                           'Infinito'
                         end
    end

    def change_first_prize
      prizes[0]['days_to_award'] = 0
      save
    end

    def select_progresive_winner
      ticket_winner = tickets_sold.sample
      ticket_winner.turn_winner!
      client = ticket_winner.x100_client

      winner = {
        id: client.id,
        name: client.name,
        phone: client.phone,
        prize_position: (winners&.size || 0) + 1,
        ticket_winner:
      }

      self.has_winners = true
      self.winners = winners&.push(winner) || [winner]
      self.status = (winners.size == prizes.size ? 'Cerrado' : 'Finalizando')
      save
    end

    def select_date_limit_winner
      results = []
      tickets_winners = tickets_sold.sample(prizes.size)

      tickets_winners = tickets_sold.sample(prizes.size) while tickets_winners.uniq.size != prizes.size

      tickets_winners.each do |ticket_winner|
        results.push(
          id: ticket_winner.x100_client.id,
          name: ticket_winner.x100_client.name,
          phone: ticket_winner.x100_client.phone,
          prize_position: results.size + 1,
          ticket_winner:
        )
      end

      self.has_winners = true
      self.status = 'Cerrado'
      self.winners = results
      save
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

    def self.current_progress_of_actives
      raffles = X100::Raffle.where(status: ['En venta', 'Finalizando']).order(id: :desc)
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

      nil unless winners.length.positive?
    end

    def validates_prizes_structure
      if prizes.nil?
        errors.add(:prizes, 'Debe agregar al menos un premio')
      else
        errors.add(:prizes, 'Debe agregar al menos un premio') if prizes.empty?

        prizes.each do |prize|
          errors.add(:prizes, 'Debe agregar un nombre al premio') if prize['name'].nil?

          errors.add(:prizes, 'Debe agregar una posicion al premio') if prize['prize_position'].nil?

          errors.add(:prizes, 'Debe agregar días para la premiación') if prize['days_to_award'].nil?
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
