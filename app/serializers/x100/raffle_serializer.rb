# == Schema Information
#
# Table name: x100_raffles
#
#  id                      :bigint           not null, primary key
#  ad                      :string
#  automatic_taquillas_ids :integer          default([]), is an Array
#  combos                  :jsonb
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
module X100
  class RaffleSerializer < ActiveModel::Serializer
    attributes :id,
               :ad,
               :title,
               :draw_type,
               :status,
               :limit,
               :money,
               :raffle_type,
               :price_unit,
               :tickets_count,
               :numbers,
               :lotery,
               :expired_date,
               :init_date,
               :prizes,
               :winners,
               :has_winners,
               :automatic_taquillas_ids,
               :shared_user_id,
               :agency,
               :created_at,
               :updated_at,
               :combos,
               :current_progress

    def created_at
      object.created_at.strftime('%d/%m/%Y %H:%M:%S')
    end

    def agency
      Shared::User.find(object.shared_user_id)
    end

    def current_progress
      tickets = X100::Ticket.where(x100_raffle_id: object.id)

      tickets_count = object.tickets_count

      current_progress = 0

      case tickets_count
      when 100
        current_progress = tickets.count
      when 1000
        current_progress = ((tickets.count.to_f / tickets_count.to_f) * 100).round(2)
      else
        current_progress = 0
      end
    end

    def updated_at
      object.updated_at.strftime('%d/%m/%Y %H:%M:%S')
    end
  end
end
