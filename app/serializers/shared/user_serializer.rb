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
#  is_integration  :boolean          default(FALSE)
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
    attributes :id, :name, :dni, :is_active, :phone, :role, :content_code

    def content_code
      object.social_influencer&.content_code
    end

    # def riferos
    #   Shared::User.where(id: object.rifero_ids)
    #               .select(:id, :dni, :email, :is_active, :phone)
    #               .map do |user|
    #     {
    #       id: user.id,
    #       dni: user.dni,
    #       email: user.email,
    #       is_active: user.is_active,
    #       role: 'Rifero',
    #       phone: user.phone
    #     }
    #   end
    # end
  end
end
