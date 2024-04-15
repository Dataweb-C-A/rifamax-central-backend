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
require "test_helper"

class Social::PaymentMethodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
