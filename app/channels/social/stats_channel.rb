class Social::StatsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'social_stats'

    # ActionCable.server.broadcast('social_stats', { message: 'Refresh stats' })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
