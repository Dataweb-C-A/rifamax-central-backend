class GlobalSingleThreadManager
  @mutex = Rails.application.config.global_thread
  @queue = Rails.application.config.global_queue
  Request = Struct.new(:args, :block)

  def self.add_request(args, block)
    @queue.push(Request.new(args, block))
    puts "Added request to queue: #{args}"
  end

  def self.all
    @queue
  end

  def self.run
    request = @queue.pop
    if request
      puts "Processing request: #{request.args}"
      @mutex.synchronize { request.block.call() }
    else
      puts "Queue is empty"
      sleep 1  # Sleep for a short duration to avoid busy-waiting
    end
  end

  def self.flush
    @queue.clear
    puts "Queue flushed"
  end
end
