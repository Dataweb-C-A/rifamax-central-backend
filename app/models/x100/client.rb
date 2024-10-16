# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_clients
#
#  id              :bigint           not null, primary key
#  dni             :string
#  email           :string
#  integrator_type :string
#  name            :string
#  phone           :string
#  pv              :boolean          default(FALSE)
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  integrator_id   :integer
#

require 'httparty'

module X100
  class Client < ApplicationRecord
    has_many :x100_tickets, class_name: 'X100::Ticket', foreign_key: 'x100_client_id'
    has_many :x100_orders, class_name: 'X100::Order', foreign_key: 'x100_client_id', dependent: :destroy

    before_destroy :tickets_acts_as_paranoid

    validates :name,
              presence: true

    validates :dni,
              uniqueness: {
                message: 'Ya existe un cliente con este número de cédula'
              },
              presence: {
                message: 'Debe introducir un número de cédula'
              },
              length: {
                minimum: 8,
                message: 'Debe ser mayor a 8 digitos'
              },
              format: {
                with: /\A[VEJG]-\d{1,8}\z/,
                message: 'Debe incluir (V J E G)'
              },
              if: -> { validates_dni_by_country }

    validates :phone,
              presence: {
                message: 'Debe introducir un número de teléfono'
              },
              uniqueness: {
                message: 'Ya existe un cliente con este número de teléfono'
              },
              format: {
                with: /\A\+\d{1,4} \(\d{1,4}\) \d{1,10}-\d{1,10}\z/,
                message: 'Introduzca un número de teléfono válido en el formato: +prefijo telefónico (codigo de area) tres primeros dígitos - dígitos restantes, por ejemplo: +58 (416) 000-0000'
              },
              if: -> { pv || integrator_id.nil? }

    validates :email,
              format: {
                with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                message: 'Introduzca un correo electrónico válido'
              },
	            if: -> { !email.nil? }

    validates :username,
              presence: {
                message: 'Debe introducir un nombre de usuario'
              },
              uniqueness: {
                message: 'Ya existe un cliente con este nombre de usuario'
              },
              if: -> { !integrator_id.nil? }

    def tickets
      x100_tickets
    end

    def validates_dni_by_country
      if integrator_id.nil?
        if phone[0..3] == '+58 '
          return true
        end
      end
      return false
    end

    def phone_belongs_to_user
      X100::Client.where(phone: phone).last
    end

    def integration_job_layer(client_id)
      url = "https://xxx.xxx.xxx/x100/clients"

      HTTParty.post(url, body: { client_id: client_id })
    end

    def exists?
      X100::Client.where(X100::Client.where(phone:)).exists?
    end

    private

    def tickets_acts_as_paranoid
      x100_tickets.update_all(
        price: nil,
        money: nil,
        status: 'available',
        x100_client_id: nil,
      )
    end
  end
end
