# == Schema Information
#
# Table name: rifamax_tickets
#
#  id                     :bigint           not null, primary key
#  is_sold                :boolean
#  is_winner              :boolean
#  number                 :integer
#  number_position        :integer
#  sign                   :string
#  uniq_identifier_serial :string
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

  belongs_to :raffle, class_name: 'Rifamax::Raffle', foreign_key: 'rifamax_raffle_id'

  private

  def initialize_ticket
    self.is_sold = false
    self.is_winner = false
    self.uniq_identifier_serial = SecureRandom.uuid
  end
end
