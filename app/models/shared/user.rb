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
  class User < ApplicationRecord
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
              presence: true

    # validates :dni,
    #           uniqueness: {
    #             message: 'Ya existe un cliente con este número de cédula'
    #           },
    #           presence: {
    #             message: 'Debe introducir un número de cédula'
    #           },
    #           length: {
    #             minimum: 8,
    #             message: 'Debe ser mayor a 8 digitos'
    #           },
    #           format: {
    #             with: /\A[VEJG]-\d{1,8}\z/,
    #             message: 'Debe incluir (V J E G)'
    #           },
    #           if: -> { phone[0..3] == '+58 ' }
              
    # validates :phone,
    #           presence: {
    #             message: 'Debe introducir un número de teléfono'
    #           },
    #           uniqueness: {
    #             message: 'Ya existe un cliente con este número de teléfono'
    #           },
    #           format: {
    #             with: /\A\+\d{1,4} \(\d{1,4}\) \d{1,10}-\d{1,10}\z/,
    #             message: 'Introduzca un número de teléfono válido en el formato: +prefijo telefónico (codigo de area) tres primeros dígitos - dígitos restantes, por ejemplo: +58 (416) 000-0000'
    #           }

    # validates :email,
    #           presence: true,
    #           uniqueness: { case_sensitive: false },
    #           format: { with: EMAIL_REGEX }

    # # validates :password,
    # #           length: { minimum: 6 },
    # #           if: -> { new_record? || !password.nil? }

    # validates :dni,
    #           presence: true,
    #           uniqueness: { case_sensitive: false },
    #           length: { minimum: 6 }

    # validate :validate_riferos

    def taquillas
      return "Can't show taquillas, user are not rifero or admin." unless %w[Rifero Admin].include?(role)

      case role
      when 'Rifero'
        Shared::User.where('rifero_ids @> ARRAY[?]', id)
      when 'Admin'
        Shared::User.where(role: 'Taquilla')
      end
    end

    def self.has_role?(role)
      Shared::User.where(role: role).count.positive?
    end

    def has_role?(role)
      self.role == role
    end

    def wallet
      shared_wallet
    end

    def validate_riferos
      return unless role != 'Taquilla' && rifero_ids.length.positive?

      errors.add(:rifero_ids, 'Cannot add riferos')
    end

    def generate_slug
      self.slug = name.parameterize
    end

    def generate_wallet
      Shared::Wallet.create(shared_user_id: id)
    end
  end
end
