# == Schema Information
#
# Table name: dev_processes
#
#  id                 :bigint           not null, primary key
#  color              :string
#  content            :string
#  priority           :string
#  process_actives_at :datetime
#  process_type       :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Dev::Process < ApplicationRecord
  validates :process_type, presence: true, inclusion: { in: %w[select_winner apart_ticket sell_ticket refund_ticket] }
  validates :content, presence: true
  validates :process_actives_at, presence: true
  validates :color, presence: true, inclusion: { in: %w[red green blue yellow] }
end
