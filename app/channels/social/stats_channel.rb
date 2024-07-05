class Social::StatsChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:content_code].present?

    influencer = Social::Influencer.find_by(content_code: params[:content_code])
    if influencer
      stream_from "social_stats_#{influencer.content_code}"
      @raffles = X100::Raffle.current_progress_of_actives

      ActionCable.server.broadcast("social_stats_#{influencer.content_code}", @raffles)
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end