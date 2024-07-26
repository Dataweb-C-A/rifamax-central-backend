class Social::RafflesDetailsChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:actions].nil?

    stream_from "social_raffles_details_#{params[:actions]}"

    ActionCable.server.broadcast("social_raffles_details_#{params[:actions]}", Social::Raffle.details(params[:actions]))
  end

  def unsubscribed
  end
end
