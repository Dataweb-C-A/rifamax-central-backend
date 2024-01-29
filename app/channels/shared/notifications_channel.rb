class Shared::NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'shared_notifications'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
