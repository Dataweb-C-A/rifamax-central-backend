# frozen_string_literal: true

class X100::RafflesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'x100_raffles'

    @raffles = X100::Raffle.current_progress_of_actives

    ActionCable.server.broadcast('x100_raffles', @raffles)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
