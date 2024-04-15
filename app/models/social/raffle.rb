# == Schema Information
#
# Table name: social_raffles
#
#  id                   :bigint           not null, primary key
#  ad                   :string
#  combos               :jsonb
#  draw_type            :string
#  expired_date         :datetime
#  has_winners          :boolean
#  init_date            :datetime
#  limit                :integer
#  money                :string
#  price_unit           :float
#  prizes               :jsonb
#  raffle_type          :string
#  status               :string
#  tickets_count        :integer
#  title                :string
#  winners              :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  social_influencer_id :bigint           not null
#
# Indexes
#
#  index_social_raffles_on_social_influencer_id  (social_influencer_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_influencer_id => social_influencers.id)
#
class Social::Raffle < ApplicationRecord
  self.table_name = 'social_raffles'

  scope :active, -> { where(status: 'En venta' )}
  scope :closing, -> { where(status: 'Finalizando' )}
  scope :closed, -> { where(status: 'Cerrado' )}

  belongs_to :social_influencer, class_name: 'Social::Influencer', foreign_key: 'social_influencer_id'
  
  mount_uploader :ad, Social::AdUploader
  has_many :social_tickets, class_name: 'Social::Ticket', foreign_key: 'social_raffle_id', dependent: :destroy
  has_many :social_orders, class_name: 'Social::Order', foreign_key: 'social_raffle_id'
  has_many :social_orders, class_name: 'Social::Order', foreign_key: 'social_raffle_id'
end
