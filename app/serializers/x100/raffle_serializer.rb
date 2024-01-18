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
               :combos

    def created_at
      object.created_at.strftime('%d/%m/%Y %H:%M:%S')
    end

    def agency
      Shared::User.find(object.shared_user_id)
    end

    def updated_at
      object.updated_at.strftime('%d/%m/%Y %H:%M:%S')
    end
  end
end