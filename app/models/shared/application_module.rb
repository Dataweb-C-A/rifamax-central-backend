# == Schema Information
#
# Table name: shared_application_modules
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Shared::ApplicationModule < ApplicationRecord
end
