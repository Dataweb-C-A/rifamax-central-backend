require 'sidekiq-scheduler'

class Shared::GenerateExchangesWorker
  include Sidekiq::Worker

  def perform(*args)
    Shared::Exchange.create(automatic: true)
  end
end
