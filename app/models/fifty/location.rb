# frozen_string_literal: true

# == Schema Information
#
# Table name: fifty_locations
#
#  id         :bigint           not null, primary key
#  capital    :string
#  estado     :string
#  id_estado  :integer
#  iso_31662  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Fifty
  class Location < ApplicationRecord
    has_many :fifty_stadia, class_name: 'Fifty::Stadium', foreign_key: 'fifty_location_id'
    has_many :fifty_towns, class_name: 'Fifty::Town', foreign_key: 'fifty_location_id'
    has_many :fifty_cities, class_name: 'Fifty::City', foreign_key: 'fifty_location_id'

    def cities
      fifty_cities
    end

    def towns
      fifty_towns
    end

    def stadiums
      fifty_stadia
    end
  end
end
