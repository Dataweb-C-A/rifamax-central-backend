class CreateSocialInfluencers < ActiveRecord::Migration[7.0]
  def change
    create_table :social_influencers do |t|
      t.string :content_code
      t.references :shared_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
