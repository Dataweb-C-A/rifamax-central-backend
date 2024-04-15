# == Schema Information
#
# Table name: social_tickets
#
#  id               :bigint           not null, primary key
#  money            :string
#  position         :integer
#  price            :float
#  serial           :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  social_raffle_id :bigint           not null
#
# Indexes
#
#  index_social_tickets_on_social_raffle_id  (social_raffle_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_raffle_id => social_raffles.id)
#
class Social::Ticket < ApplicationRecord
  include AASM
  
  belongs_to :social_raffle, class_name: 'Social::Raffle', foreign_key: 'social_raffle_id'

  aasm column: 'status' do
    state :available, initial: true
    state :reserved
    state :sold
    state :winner

    event :apart do
      transitions from: :available, to: :reserved
    end

    event :sell do
      transitions from: :reserved, to: :sold
    end

    event :turn_available do
      transitions from: :reserved, to: :available
    end

    event :turn_winner do
      transitions from: :sold, to: :winner
    end
  end
end
