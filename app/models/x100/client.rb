# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module X100
  class Client < ApplicationRecord
    has_many :x100_tickets, class_name: 'X100::Ticket', foreign_key: 'x100_client_id'

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
                message: "Debe incluir (V J E G)"
              },
              if: -> { phone[0..3] == '+58 ' }

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
              }

    validates :email,
              presence: {
                message: 'Debe introducir un correo electrónico'
              },
              format: {
                with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                message: 'Introduzca un correo electrónico válido'
              },
              uniqueness: {
                message: 'Ya existe un cliente con este correo electrónico'
              }

    def tickets
      x100_tickets
    end
  end
end
