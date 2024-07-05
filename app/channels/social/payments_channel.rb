class Social::PaymentsChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:content_code].present?

    influencer = Social::Influencer.find_by(content_code: params[:content_code])
    if influencer
      stream_from "social_payments_#{influencer.content_code}"
      payments_active = X100::Raffle.current_progress_of_actives

      ActionCable.server.broadcast("social_payments_#{influencer.content_code}", payments_active)
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
