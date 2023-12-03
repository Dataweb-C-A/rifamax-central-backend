# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_application_modules
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Shared
  class ApplicationModule < ApplicationRecord
  end
end
