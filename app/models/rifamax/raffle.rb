# == Schema Information
#
# Table name: rifamax_raffles
#
#  id                     :bigint           not null, primary key
#  admin_status           :integer
#  currency               :string
#  expired_date           :date
#  init_date              :date
#  lotery                 :string
#  numbers                :integer
#  payment_info           :jsonb
#  price                  :float
#  prizes                 :jsonb            is an Array
#  security               :jsonb
#  sell_status            :integer
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
  enum sell_status: { available: 0, sent: 1, sold: 2 }
  enum admin_status: { pending: 0, payed: 1, unpayed: 2, refunded: 3 }

  # Triggers and Callbacks
  before_create :set_expired_date
  before_create :initiliaze_statues
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

  validates :init_date,
            presence: true,
            comparison: { greater_than: Date.yesterday }
            
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

  def self.filter_by_status(user_id, endpoint = 'newest')
    begin
      user = Shared::User.find_by(id: user_id, role: %w[Taquilla Rifero Admin])
      raise StandardError, "Can't perform this action" unless user
      
      case user.role
      when 'Taquilla'
        Rifamax::Raffle.where(user_id: user.id)
      when 'Rifero'
        Rifamax::Raffle.where(seller_id: user.id).where(statues_by_endpoint(endpoint))
      when 'Admin'
        Rifamax::Raffle.where(statues_by_endpoint(endpoint))
      else
        { error: "You are not allowed to perform this action" }
      end
    rescue StandardError => e
      { error: e.message }
    end
  end

  def self.need_to_close(user_id, endpoint = 'newest')
    begin
      user = Shared::User.find_by(id: user_id, role: %w[Taquilla Admin])
      raise StandardError, "Can't perform this action" unless user

      case user.role
      when 'Taquilla'
        Rifamax::Raffle.where('expired_date < ?', Date.today, user_id: user.id)
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

  def self.statues_by_endpoint(endpoint)
    case endpoint
    when 'newest'
      { sell_status: :available, admin_status: :pending }
    when 'initialized'
      { sell_status: [SENT, SOLD], admin_status: PENDING, expired_date: Date.today..Date.new }
    when 'to_close'
      { sell_status: [SENT, SOLD], admin_status: PENDING, expired_date: Date.new..Date.today }
    else
      { sell_status: :available, admin_status: :pending }
    end
  end
  
  def set_security(wildcards)
    position = rand(1..12)

    self.security = {
      position: position,
      wildcard: wildcards[position - 1]
    }
    self.save
  end

  def generate_tickets
    case lotery
    when 'Zulia 7A'
      generate_tickets_for_category(ZODIAC)
      set_security(ZODIAC)
    when 'Zulia 7B'
      generate_tickets_for_category(ZODIAC)
      set_security(ZODIAC)
    when 'Triple Pelotica'
      generate_tickets_for_category(WILDCARDS)
      set_security(WILDCARDS)
    else
      errors.add(:lotery, 'Lotery is not valid')
    end
  end

  def set_expired_date
    self.expired_date = init_date + 3.day
  end

  def initiliaze_statues
    self.sell_status = 0
    self.admin_status = 0
  end

  def generate_tickets_for_category(category)
    if tickets.any?
      errors.add(:tickets, 'Tickets already exists')
      return
    end
    ActiveRecord::Base.transaction do
      category.each_with_index do |item, index|
        Rifamax::Ticket.create(
          wildcard: item,
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
    errors.add(:seller_id, 'Must be belongs to user') unless user.rifero_ids.include?(seller.id)
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
