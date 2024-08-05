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
  include AASM

  belongs_to :user, class_name: 'Shared::User', foreign_key: 'user_id'
  belongs_to :seller, class_name: 'Shared::User', foreign_key: 'seller_id'

  has_many :tickets, class_name: 'Rifamax::Ticket', foreign_key: 'rifamax_raffle_id', dependent: :destroy

  aasm column: 'sell_status' do 
    state :active, initial: true
    state :sent
    state :sold
    state :expired

    event :send do
      transitions from: :active, to: :sent
    end

    event :sell do
      transitions from: :active, to: :sold
    end

    event :expire_all_sold do
      transitions from: :sold, to: :expired
    end

    event :expire do
      transitions from: :active, to: :expired
    end
  end

  aasm column: 'admin_status' do
    state :pending, initial: true
    state :payed
    state :unpayed
    state :refunded

    event :pay do
      transitions from: :pending, to: :payed
    end

    event :unpay do
      transitions from: :pending, to: :unpayed
    end

    event :refund do
      transitions from: :pending, to: :refunded
    end
  end

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
    case game
    when 'Zodiac'
      generate_tickets_for_category(ZODIAC)
    when 'Wildcards'
      generate_tickets_for_category(WILDCARDS)
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
    rescue StandardError => e
      { error: e.message }
    end
  end

  private

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
end
