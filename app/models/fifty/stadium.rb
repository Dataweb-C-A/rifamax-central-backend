# == Schema Information
#
# Table name: fifty_stadia
#
#  id             :bigint           not null, primary key
#  fifty_location :integer          not null
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Fifty::Stadium < ApplicationRecord
  belongs_to :fifty_location, class_name: 'Fifty::Stadium', foreign_key: 'fifty_location_id'
end
