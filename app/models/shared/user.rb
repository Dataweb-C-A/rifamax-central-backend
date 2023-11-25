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
class Shared::User < ApplicationRecord
  has_one :shared_wallet, class_name: 'Shared::Wallet', foreign_key: 'shared_user_id'
  has_secure_password

  after_create :generate_wallet

  enum :role, { 
                Admin: 'admin', 
                Agente: 'agente', 
                Taquilla: 'taquilla', 
                Rifero: 'rifero', 
                Autotaquilla: 'autotaquilla' 
              }
  
  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, 
            presence: true
  
  validates :role, 
            presence: :true
  
  validates :email, 
            presence: true, 
            uniqueness: { case_sensitive: false }, 
            format: { with: EMAIL_REGEX }

  validates :password,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }

  validates :dni,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 6 }

  def generate_wallet
    Shared::Wallet.create(shared_user_id: self.id)
  end
end
