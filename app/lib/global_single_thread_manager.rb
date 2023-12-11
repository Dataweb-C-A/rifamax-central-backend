# frozen_string_literal: true

class GlobalSingleThreadManager
  @mutex = Rails.application.config.global_thread
  @queue = Rails.application.config.global_queue.reverse
  Request = Struct.new(:args, :block)

  def self.job_later(args, block)
    @queue.push(Request.new(args, block))
    puts "Added request to queue: #{args}"
  end

  def self.all
    @queue
  end

  def self.run
    request = @queue.pop
    Thread.new do
      if request
        puts "Processing request: #{request.args}"
        @mutex.synchronize { request.block.call }
      else
        puts 'Queue is empty'
        sleep 1
      end
    end
  end

  def self.run_all
    run while @queue.length.positive?
  end

  def self.add_tasks(args, block)
    @queue.push(Request.new(args, block))
    puts "Added request to queue: #{args}"
    run_all
  end

  def self.flush
    @queue.clear
    puts 'Queue flushed'
  end
end
