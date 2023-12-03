# frozen_string_literal: true

class CreateSharedApplicationModules < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_application_modules do |t|
      t.string :title

      t.timestamps
    end
  end
end
