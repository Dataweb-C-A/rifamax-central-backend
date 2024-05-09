# frozen_string_literal: true

# == Schema Information
#
# Table name: x100_clients
#
#  id              :bigint           not null, primary key
#  dni             :string
#  email           :string
#  integrator_type :string
#  name            :string
#  phone           :string
#  pv              :boolean          default(FALSE)
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  integrator_id   :integer
#
module X100
  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :name, :dni, :phone, :email
  end
end
