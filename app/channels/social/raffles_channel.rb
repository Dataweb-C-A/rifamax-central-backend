class Social::RafflesChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:content_code].present?

    influencer = Social::Influencer.find_by(content_code: params[:content_code])
    if influencer
      stream_from "social_raffles_#{influencer.content_code}"

      ActionCable.server.broadcast("social_raffles_#{influencer.content_code}", @raffles)
    else
      reject
    end
  end

  def unsubscribed
  end
end