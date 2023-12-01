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
  after_create :generate_slug

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

  # Validations
  
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

  validate :validate_riferos

  def taquillas
    if !['Rifero', 'Admin'].include?(self.role)
      return "Can't show taquillas, user are not rifero or admin."
    else
      case self.role
        when 'Rifero'
        Shared::User.where("rifero_ids @> ARRAY[?]", self.id)
        when 'Admin'
        Shared::User.where(role: 'Taquilla')
      end
    end
  end

  def wallet
    self.shared_wallet
  end

  def validate_riferos
    if (self.role != 'Taquilla' && self.rifero_ids.length > 0)
      errors.add(:rifero_ids, "Cannot add riferos")
    end
  end

  def generate_slug
    self.slug = self.name.parameterize
  end

  def generate_wallet
    Shared::Wallet.create(shared_user_id: self.id)
  end
end
