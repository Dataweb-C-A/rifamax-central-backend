# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_orders
#
#  id                   :bigint           not null, primary key
#  amount               :float
#  integrator           :string
#  money                :string
#  ordered_at           :datetime
#  products             :integer          default([]), is an Array
#  serial               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  integrator_player_id :integer
#  shared_exchange_id   :bigint           not null
#  shared_user_id       :bigint           not null
#  x100_client_id       :bigint           not null
#  x100_raffle_id       :bigint           not null
#
# Indexes
#
#  index_x100_orders_on_shared_exchange_id  (shared_exchange_id)
#  index_x100_orders_on_shared_user_id      (shared_user_id)
#  index_x100_orders_on_x100_client_id      (x100_client_id)
#  index_x100_orders_on_x100_raffle_id      (x100_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (shared_exchange_id => shared_exchanges.id)
#  fk_rails_...  (shared_user_id => shared_users.id)
#  fk_rails_...  (x100_client_id => x100_clients.id)
#  fk_rails_...  (x100_raffle_id => x100_raffles.id)
#
module X100
  class Order < ApplicationRecord
    require 'httparty'
    require 'uri'

    belongs_to :shared_user, class_name: 'Shared::User', foreign_key: 'shared_user_id'
    belongs_to :x100_client, class_name: 'X100::Client', foreign_key: 'x100_client_id'
    belongs_to :x100_raffle, class_name: 'X100::Raffle', foreign_key: 'x100_raffle_id'
    belongs_to :shared_exchange, class_name: 'Shared::Exchange', foreign_key: 'shared_exchange_id'
  
    validates :money,
              presence: true,
              inclusion: { in: %w[VES USD COP] }

    validates :integrator,
              presence: true,
              inclusion: { in: %w[CDA] },
              if: -> { integrator.present? }

    validates :integrator_player_id,
              presence: true,
              if: -> { integrator.present? }

    def x100_tickets
      X100::Ticket.where(position: products, x100_raffle_id: x100_raffle_id)
    end

    def price_without_discount
      X100::Ticket.where(position: products, x100_raffle_id: x100_raffle_id).sum(:price)
    end

    def transform_amount_to_dolar
      case money
      when 'VES'
        amount / shared_exchange.value_bs
      when 'COP'
        amount / shared_exchange.value_cop
      else
        amount
      end
    end

    def discount_rate
      (self.price_without_discount - self.transform_amount_to_dolar) / self.price_without_discount
    end

    def integrator_job
      return false if (!integrator.present? || !integrator_player_id.present?)

      case integrator
      when 'CDA'
        @payload = {
          id: id,
          amount: amount,
          serial: serial,
          tickets: x100_tickets.map do |ticket|
            {
              id: ticket[:id],
              position: ticket[:position],
              serial: ticket[:serial],
              price: ticket[:price],
              money: ticket[:money],
              status: ticket[:status]
            }
          end,
          tx_transaction: 'DEBIT',
          currency: money,
          player_id: integrator_player_id,
          x100_raffle: {
            raffle_image: "https://api.rifa-max.com/#{x100_raffle.ad.url}",
            title: x100_raffle.title,
            status: x100_raffle.status,
            money: x100_raffle.money,
            raffle_type: x100_raffle.raffle_type,
            price_unit: x100_raffle.price_unit,
            tickets_count: x100_raffle.tickets_count,
            lotery: x100_raffle.lotery
          }
        }

        url = "https://dataweb.testcda.com/wallets_rifas/debit"

        response = HTTParty.post(url, :body => @payload.to_json, :headers => { 'Content-Type' => 'application/json' })

        if (response.code == 200) 
          return true
        else
          return false
        end
      else
        return true
      end
    end
  end
end
