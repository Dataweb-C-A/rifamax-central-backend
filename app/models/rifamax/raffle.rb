# == Schema Information
#
# Table name: rifamax_raffles
#
#  id                     :bigint           not null, primary key
#  admin_status           :string
#  currency               :string
#  expired_date           :date
#  init_date              :date
#  lotery                 :string
#  numbers                :integer
#  price                  :float
#  prizes                 :jsonb            is an Array
#  sell_status            :string
#  title                  :string
#  uniq_identifier_serial :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  seller_id              :bigint           not null
#  user_id                :bigint           not null
#
# Indexes
#
#  index_rifamax_raffles_on_seller_id  (seller_id)
#  index_rifamax_raffles_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (seller_id => shared_users.id)
#  fk_rails_...  (user_id => shared_users.id)
#
class Rifamax::Raffle < ApplicationRecord
  # Enums
  ACTIVE = :active
  SENT = :sent
  SOLD = :sold

  PENDING = :pending
  PAYED = :payed
  UNPAYED = :unpayed
  REFUNDED = :refunded

  enum :sell_status,
        { active: ACTIVE, 
          sent: SENT, 
          sold: SOLD 
        }.transform_values(&:to_s),
        default: ACTIVE.to_s,
        validate: true

  enum :admin_status,
        { pending: PENDING, 
          payed: PAYED, 
          unpayed: UNPAYED, 
          refunded: REFUNDED 
        }.transform_values(&:to_s),
        default: PENDING.to_s,
        validate: true

  # Triggers and Callbacks
  after_initialize :set_expired_date
  after_initialize :initiliaze_statues
  before_create :generate_uniq_identifier_serial
  after_create :generate_tickets

  # Associations
  belongs_to :user, class_name: 'Shared::User', foreign_key: 'user_id'
  belongs_to :seller, class_name: 'Shared::User', foreign_key: 'seller_id'

  has_many :tickets, class_name: 'Rifamax::Ticket', foreign_key: 'raffle_id', dependent: :destroy

  # Scopes
  scope :expired, -> { where('expired_date < ?', Date.today) }
  scope :active, -> { where('init_date <= ? AND expired_date >= ?', Date.today, Date.today) }

  # Validations
  validates :title,
            presence: true,
            length: { minimum: 3, maximum: 35 }
    
  validates :currency,
            presence: true,
            inclusion: { in: %w[USD VES COP] }

  validates :lotery,
            presence: true,
            inclusion: { in: ['Zulia 7A', 'Zulia 7B', 'Triple Pelotica'] }

  validates :numbers,
            presence: true,
            numericality: { 
              only_integer: true, 
              greater_than: 0, 
              less_than: 1000 
            }
          
  validates :price,
            presence: true,
            numericality: {
              greater_than: 0
            }

  validate :validates_expired_date
  validate :validates_user
  validate :validates_seller
  validate :validates_prizes

  ZODIAC = %w[
    Aries
    Tauro
    Geminis
    Cancer
    Leo
    Virgo
    Libra
    Escorpio
    Sagitario
    Capricornio
    Acuario
    Piscis
  ].freeze

  WILDCARDS = [
    'Baloncesto',
    'Beisbol',
    'Futbol',
    'Voleibol',
    'Playa',
    'Golf',
    'Futbol Américano',
    'Tenis',
    'Billar',
    'Bowling',
    'Ping Pong',
    'Hockey'
  ].freeze

  def generate_tickets
    case lotery
    when 'Zulia 7A'
      generate_tickets_for_category(ZODIAC)
    when 'Zulia 7B'
      generate_tickets_for_category(ZODIAC)
    when 'Triple Pelotica'
      generate_tickets_for_category(WILDCARDS)
    else
      errors.add(:lotery, 'Lotery is not valid')
    end
  end


  def self.active_today(user_id)
    begin
      user = Shared::User.find_by(id: user_id, role: %w[Taquilla Rifero Admin])
      raise StandardError, "Can't perform this action" unless user
      
      case user.role
      when 'Taquilla'
        Rifamax::Raffle.where(user_id: user.id, sell_status: 'active')
      when 'Rifero'
        Rifamax::Raffle.where(seller_id: user.id, sell_status: 'active')
      when 'Admin'
        Rifamax::Raffle.where(sell_status: 'active')
      end
    else
      { error: "You are not allowed to perform this action" }
    end
    rescue StandardError => e
      { error: e.message }
    end
  end

  def self.need_to_close(user_id)
    begin
      user = Shared::User.find_by(id: user_id, role: %w[Taquilla Admin])
      raise StandardError, "Can't perform this action" unless user

      case user.role
      when 'Taquilla'
        Rifamax::Raffle.where('expired_date < ?', Date.today, user_id: user.id, admin_status: 'pending')
      when 'Admin'
        Rifamax::Raffle.where('expired_date < ?', Date.today, admin_status: 'pending')
      else
        { error: "You are not allowed to perform this action" }
      end 
    rescue StandardError => e
      { error: e.message }
    end
  end

  private

  def set_expired_date
    self.expired_date = init_date + 3.day
  end

  def initiliaze_statues
    self.sell_status = 'active'
    self.admin_status = 'pending'
  end

  def generate_tickets_for_category(category)
    ActiveRecord::Base.transaction do
      category.each_with_index do |item, index|
        Rifamax::Ticket.create(
          sign: item,
          number: numbers,
          number_position: index + 1,
          is_sold: false,
          raffle_id: id
        )
      end
    end
  end

  def generate_uniq_identifier_serial
    self.uniq_identifier_serial = SecureRandom.uuid
  end

  # Validations

  def validates_user
    errors.add(:user_id, 'You are not allowed to perform this action') unless user.role == 'Taquilla'
  end

  def validates_seller
    errors.add(:seller_id, 'You are not allowed to perform this action') unless seller.role == 'Rifero'
  end

  def validates_expired_date
    errors.add(:expired_date, 'Expired date must be greater than init date') if expired_date <= init_date
  end

  def validates_prizes
    errors.add(:prizes, 'Prizes must be an array') unless prizes.is_a?(Array)

    prizes.each do |prize|
      errors.add(:prizes, 'Prize must be a hash') unless prize.is_a?(Hash)
      errors.add(:prizes, 'Prize must have award key') unless prize.key?('award')
      errors.add(:prizes, 'Prize must have plate key') unless prize.key?('plate')
      errors.add(:prizes, 'Prize must have is_money key') unless prize.key?('is_money')
      errors.add(:prizes, 'Prize must have wildcard key') unless prize.key?('wildcard')
    end
  end
end
