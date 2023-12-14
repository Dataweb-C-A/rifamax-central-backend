# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_users
#
#  id              :bigint           not null, primary key
#  avatar          :string
#  dni             :string
#  email           :string
#  is_active       :boolean
#  module_assigned :integer          default([]), is an Array
#  name            :string
#  password_digest :string
#  phone           :string
#  rifero_ids      :integer          default([]), is an Array
#  role            :string
#  slug            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
module Shared
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :dni, :is_active, :access, :phone, :role, :riferos
    
    def access
      modules = [
        {
          id: 1,
          name: 'Rifamax'
        },
        {
          id: 2,
          name: 'X100'
        },
        {
          id: 3,
          name: '50/50'
        }
      ]
      object.module_assigned.map do |module_assigned|
        {
          id: module_assigned,
          name: modules.select { |item| item[:id] == module_assigned }
        }
      end
    end

    def riferos
      Shared::User.where(id: object.rifero_ids)
                  .select(:id, :dni, :email, :is_active, :phone)
                  .map do |user|
        {
          id: user.id,
          dni: user.dni,
          email: user.email,
          is_active: user.is_active,
          role: 'Rifero',
          phone: user.phone
        }
      end
    end
  end
end
