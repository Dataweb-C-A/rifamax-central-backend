# == Schema Information
#
# Table name: rifamax_tickets
#
#  id                     :bigint           not null, primary key
#  is_sold                :boolean
#  is_winner              :boolean
#  number                 :integer
#  number_position        :integer
#  uniq_identifier_serial :string
#  wildcard               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  raffle_id              :bigint           not null
#
# Indexes
#
#  index_rifamax_tickets_on_raffle_id  (raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (raffle_id => rifamax_raffles.id)
#
class Rifamax::Ticket < ApplicationRecord
  before_create :initialize_ticket

  belongs_to :raffle, class_name: 'Rifamax::Raffle', foreign_key: 'raffle_id'

  def self.clean
    expired_raffle_ids = Rifamax::Raffle.expired.pluck(:id)
    Rifamax::Ticket.where(raffle_id: expired_raffle_ids, is_winner: false).delete_all
  end

  private

  def initialize_ticket
    self.is_sold = false
    self.is_winner = false
    self.uniq_identifier_serial = SecureRandom.uuid
  end
end
