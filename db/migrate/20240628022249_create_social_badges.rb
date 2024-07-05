class CreateSocialBadges < ActiveRecord::Migration[7.0]
  def change
    create_table :social_badges do |t|
      t.string :title
      t.string :color
      t.string :icon
      t.references :social_influencer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
