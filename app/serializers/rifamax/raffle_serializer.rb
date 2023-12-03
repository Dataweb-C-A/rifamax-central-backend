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
  class RaffleSerializer < ActiveModel::Serializer
    attributes :id
  end
end
