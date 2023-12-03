# frozen_string_literal: true

# == Schema Information
#
# Table name: rifamax_raffles
#
#  id            :bigint           not null, primary key
#  award_no_sign :string
#  award_sign    :string
#  expired_date  :date
#  game          :string           default("Zodiac")
#  init_date     :date
#  is_closed     :boolean
#  is_send       :boolean
#  loteria       :string
#  numbers       :integer
#  plate         :string
#  price         :float
#  refund        :boolean
#  serial        :string
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  payment_id    :integer
#  rifero_id     :integer
#  taquilla_id   :integer
#
module Rifamax
  class Raffle < ApplicationRecord
    has_many :rifamax_tickets, class_name: 'Rifamax::Ticket', foreign_key: 'rifamax_raffle_id'
    after_create :generate_tickets

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
      'Futbol Americano',
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

    private

    def generate_tickets_for_category(category)
      ActiveRecord::Base.transaction do
        category.each_with_index do |item, index|
          Rifamax::Ticket.create(
            sign: item,
            number: numbers,
            ticket_nro: index + 1,
            serial: SecureRandom.hex(5),
            is_sold: false,
            rifamax_raffle_id: id
          )
        end
      end
    end
  end
end
