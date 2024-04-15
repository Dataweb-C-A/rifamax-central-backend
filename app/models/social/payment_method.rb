# == Schema Information
#
# Table name: social_payment_methods
#
#  id               :bigint           not null, primary key
#  details          :jsonb
#  payment          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  social_client_id :bigint           not null
#
# Indexes
#
#  index_social_payment_methods_on_social_client_id  (social_client_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_client_id => social_clients.id)
#
class Social::PaymentMethod < ApplicationRecord
  belongs_to :social_client, class_name: 'Social::Client', foreign_key: 'social_client_id'

  has_many :social_orders, class_name: 'Social::Order', foreign_key: 'social_payment_method_id', dependent: :destroy

  validates :payment, 
            presence: true, 
            inclusion: { in: ["Stripe", "Pago Movil", "Zelle", "Paypal"] }

  validates :details, presence: true

  validate :validates_details
  
  private
  
  def validates_details
    case payment
    when "Stripe"
      validates_stripe
    when "Pago Movil"
      validates_pago_movil
    when "Zelle"
      validates_zelle
    when "Paypal"
      validates_paypal
    end
  end

  def validates_stripe
    errors.add(:details, "Bank is not present") unless details["bank"].present?
    errors.add(:details, "Name is not present") unless details["name"].present?
    errors.add(:details, "Last four digits is not present") unless details["last_digits"].present?
  end

  def validates_pago_movil
    errors.add(:details, "Bank is not present") unless details["bank"].present?
    errors.add(:details, "Phone is not present") unless details["phone"].present?
    errors.add(:details, "DNI is not present") unless details["dni"].present?
  end

  def validates_zelle
    errors.add(:details, "Bank is not present") unless details["bank"].present?
    errors.add(:details, "Email is not present") unless details["email"].present?
  end

  def validates_paypal
    errors.add(:details, "Email is not present") unless details["email"].present?
  end
end
