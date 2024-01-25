require_relative "config/environment"
    
$redis.config('SET', 'notify-keyspace-events', 'KEA')

redis.psubscribe('__keyevent@0__:expired') do |on|
  on.pmessage do |pattern, event, key|
    puts ("pattern: #{pattern}")
    puts ("event: #{event}")
    puts ("key: #{key}")
    Rails.logger.info(Shared::User.last.id)
  end
end