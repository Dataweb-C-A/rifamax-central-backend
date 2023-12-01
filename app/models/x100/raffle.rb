# == Schema Information
#
# Table name: x100_raffles
#
#  id                      :bigint           not null, primary key
#  ad                      :string
#  automatic_taquillas_ids :integer          default([]), is an Array
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
class X100::Raffle < ApplicationRecord
  after_create :generate_tickets
  after_create :initialize_status
  after_create :initialize_winners

  validates :title,
            presence: true,
            length: {
                      minimum: 5,
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
            inclusion: { in: %w[BsF $ COP] }

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

  validate :validates_draw_types

  validate :validates_shared_user

  validate :validates_automatic_taquillas

  def self.raffles_by_user(user)
    case user.role
    when 'Taquilla'
      X100::Raffle.where(shared_user_id: user.id).select { |item| item.status != 'Cerrada' }
    when 'Autotaquilla'
      X100::Raffle.select { |item| item.automatic_taquillas_ids.include?(user.id) && item.status != 'Cerrada' }
    when 'Admin'
      X100::Raffle.select { |item| item.status != 'Cerrada' }
    end
  end

  private

  def initialize_status
    self.status = 'En venta'
    self.save
  end

  def initialize_winners
    self.has_winners = false
    self.save
  end 

  def validates_winners_structure
    if !self.winners.nil? 
      if self.winners.length > 0
        self.winners.each do |winner|
          if winner[:name] == nil
            errors.add(:winners, 'Debe agregar un nombre al ganador')
          end

          if winner[:phone] == nil
            errors.add(:winners, 'Debe agregar un telefono al ganador')
          end

          if winner[:dni] == nil
            errors.add(:winners, 'Debe agregar un dni al ganador')
          end

          if winner[:prize_position] == nil
            errors.add(:winners, 'Debe agregar una posicion al ganador')
          end

          if winner[:ticket_winner] == nil
            errors.add(:winners, 'Debe agregar un ticket al ganador')
          end
        end
      end
    end
  end

  def validates_prizes_structure
    if self.prizes.nil? 
      errors.add(:prizes, 'Debe agregar al menos un premio')
    else
      if self.prizes.length == 0 
        errors.add(:prizes, 'Debe agregar al menos un premio')
      end
  
      self.prizes.each do |prize|
        if prize["name"] == nil
          errors.add(:prizes, 'Debe agregar un nombre al premio')
        end
  
        if prize["prize_position"] == nil
          errors.add(:prizes, 'Debe agregar una posicion al premio')
        end
      end
    end
  end 

  def validates_draw_types
    allowed_draw_types = ['Progresiva', 'Fecha limite', 'Infinito']
  
    if allowed_draw_types.include?(self.draw_type) == false
      errors.add(:draw_type, 'Tipo de rifa no permitido')
    end
  end

  def validates_automatic_taquillas
    if self.automatic_taquillas_ids.length > 0
      self.automatic_taquillas_ids.each do |taquilla_id|
        if Shared::User.find(taquilla_id).role != 'Taquilla'
          errors.add(:automatic_taquillas_ids, 'El usuario no es una taquilla')
        end
      end
    end
  end

  def validates_shared_user
    if Shared::User.find(self.shared_user_id).role != 'Taquilla'
      errors.add(:shared_user_id, 'El usuario no es una taquilla')
    end
  end

  def generate_tickets
    redis = Redis.new

    @tickets = []

    self.tickets_count.times do |index|
      @tickets << {
        position: index + 1,
        is_sold: false,
        sold_to: {},
        serial: SecureRandom.hex(32) + index.to_s
      }
    end

    case self.tickets_count
    when 100
      self.raffle_type = 'Terminal'
      self.save
      redis.set("raffle_tickets:#{self.id}", @tickets.to_json)
    when 1000
      self.raffle_type = 'Triple'
      self.save
      redis.set("raffle_tickets:#{self.id}", @tickets.to_json)
    else
      self.raffle_type = 'Infinito'
      self.save
    end
  end
end
