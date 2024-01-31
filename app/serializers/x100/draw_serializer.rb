module X100
  class DrawSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :draw_type,
               :status,
               :limit,
               :price_unit,
               :expired_date,
               :init_date,
               :prizes,
               :current_progress

    def current_progress
      tickets = X100::Ticket.where(x100_raffle_id: object.id, status: 'sold')

      tickets_count = object.tickets_count

      case tickets_count
      when 100
        tickets.count
      when 1000
        ((tickets.count.to_f / 1000) * 100).round(2)
      else
        0
      end
    end
  end
end
