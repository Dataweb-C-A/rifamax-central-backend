# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_orders
#
#  id                   :bigint           not null, primary key
#  amount               :float
#  integrator           :string
#  logs                 :jsonb            is an Array
#  money                :string
#  ordered_at           :datetime
#  products             :integer          default([]), is an Array
#  serial               :string
#  status               :string           default("active")
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

    after_save :generate_order_infinity
  
    validates :money,
              presence: true,
              inclusion: { in: %w[VES USD COP] }

    validates :status,
              presence: true,
              inclusion: { in: %w[active refunded] }

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

    def generate_order_infinity
      cda_url = ENV['cda_url_base']

      return unless integrator.present? || integrator_player_id.present?

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
            lotery: x100_raffle.lotery,
            draw_type: x100_raffle.draw_type,
            expired_date: x100_raffle.expired_date == nil ? nil : x100_raffle.expired_date.strftime("%d/%m/%Y - %H:%M"),
          }
        }

        url = "#{cda_url}/wallets_rifas/debit"

        response = HTTParty.post(url, :body => @payload.to_json, :headers => { 'Content-Type' => 'application/json' })

        return true if response.code == 200
        return false
      else
        return true
      end
    end

    def price_without_discount
      X100::Ticket.where(position: products, x100_raffle_id: x100_raffle_id).sum(:price)
    end

    def price_without_discount_from_logs
      logs.map { |log| log['price'] }.compact.sum
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

    def self.invoices(date_init = Time.now, date_end = Time.now, taquilla = nil, client = nil)
      payload = {
        ordered_at: date_init..date_end,
        x100_client_id: client&.id,
        shared_user_id: taquilla&.id,
      }
      currencies =  [:USD, :VES, :COP]

      orders = X100::Order.where(payload.compact, status: 'active').group_by { |order| order.money }.transform_values { |orders| orders.sum(&:amount) }

      # invoice = {
      #   count_of_orders: @orders.count,
      #   profit: currencies.map { |currency| orders}
      # }
    end

    def discount_rate_from_logs
      (self.price_without_discount_from_logs - self.transform_amount_to_dolar) / self.price_without_discount_from_logs
    end

    def cda_payload(tx_transaction)
      return {
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
        tx_transaction: tx_transaction,
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
          lotery: x100_raffle.lotery,
          draw_type: x100_raffle.draw_type,
          expired_date: x100_raffle.expired_date == nil ? nil : x100_raffle.expired_date.strftime("%d/%m/%Y - %H:%M"),
        }
      }
    end

    def integrator_job
      return false unless (integrator.present? || integrator_player_id.present?)
      url = ENV['cda_url_base']

      case integrator
      when 'CDA'
        @payload = cda_payload('DEBIT')

        url_parse = "#{url}/wallets_rifas/debit"

        response = HTTParty.post(url, :body => @payload.to_json, :headers => { 'Content-Type' => 'application/json' })

        Rails.logger.info(response.body.as_json)

        return true if response.code == 200
        return false
      else
        return true
      end
    end

    def integrator_credit_job
      return false unless (integrator.present? || integrator_player_id.present?)
      url = ENV['cda_url_base']

      case integrator
      when 'CDA'
        @payload = cda_payload('CREDIT')

        url_parse = "#{url}/wallets_rifas/credit"

        response = HTTParty.post(url, :body => @payload.to_json, :headers => { 'Content-Type' => 'application/json' })

        return true if response.code == 200
        return false
      else
        return true
      end
    end

    def refund_order!
      @x100_tickets = x100_tickets
      self.update(status: 'refunded', logs: JSON.parse(@x100_tickets.to_json), products: [])

      if self.x100_raffle.draw_type == 'Infinito'
        @x100_tickets.destroy_all
      else
        @x100_tickets.update_all(price: nil, x100_client_id: nil, status: 'available')
      end

      @payload = {
          id: id,
          amount: amount,
          serial: serial,
          tickets: x100_tickets.map do |ticket|
            {
              id: ticket[:id],
              position: ticket[:position],
              serial: ticket[:serial],
              price: nil,
              money: nil,
              status: 'available'
            }
          end,
          tx_transaction: 'DEBIT',
          currency: money,
          player_id: integrator_player_id,
          status: 'refunded',
          x100_raffle: {
            raffle_image: "https://api.rifa-max.com/#{x100_raffle.ad.url}",
            title: x100_raffle.title,
            status: x100_raffle.status,
            money: x100_raffle.money,
            raffle_type: x100_raffle.raffle_type,
            price_unit: x100_raffle.price_unit,
            tickets_count: x100_raffle.tickets_count,
            lotery: x100_raffle.lotery,
            draw_type: x100_raffle.draw_type,
            expired_date: x100_raffle.expired_date,
          }
        }

      return @payload
    end
  end
end
