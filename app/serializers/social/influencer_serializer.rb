class Social::InfluencerSerializer < ActiveModel::Serializer
  attributes :id, :influencer_id, :name, :content_code

  def id
    object.shared_user.id
  end

  def name
    object.shared_user.name
  end

  def influencer_id
    object.id
  end
end
