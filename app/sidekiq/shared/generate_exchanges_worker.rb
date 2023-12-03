# frozen_string_literal: true

require 'sidekiq-scheduler'

module Shared
  class GenerateExchangesWorker
    include Sidekiq::Worker

    def perform(*_args)
      Shared::Exchange.create(automatic: true)
    end
  end
end
