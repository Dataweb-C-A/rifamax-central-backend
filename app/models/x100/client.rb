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
              uniqueness: true,
              presence: true,
              length: {
                minimum: 8
              },
              inclusion: { in: ["V-", "J-", "E-", "G-"] },
              if: -> { self.phone[0..3] == "+58 " }

    validates :phone,
              presence: true,
              format: { 
                      with: /\A\+\d{1,4} \(\d{1,4}\) \d{1,10}-\d{1,10}\z/, 
                      message: "Introduzca un número de teléfono válido en el formato: +prefijo telefónico (codigo de area) tres primeros dígitos - dígitos restantes, por ejemplo: +58 (416) 000-0000"
              }

    validates :email,
              presence: true,
              uniqueness: true

    def tickets
      self.x100_tickets
    end              
  end
end
