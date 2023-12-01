# == Schema Information
#
# Table name: x100_clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class X100::ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :dni, :phone, :email
end
