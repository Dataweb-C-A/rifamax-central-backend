class X100::TicketsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tickets"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
