class X100::RafflesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'x100_raffles'

    @raffles = X100::Raffle.order(:id).reverse

    ActionCable.server.broadcast('x100_raffles', @raffles)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
