module OnlineTracker
  extend ActiveSupport::Concern

  module ClassMethods
    # Who's online
    def online_ids
      REDIS.sunion(*keys_in_last_n_minutes(self::ONLINE_MINUTE))
    end

    def key(minute)
      "online_#{name}_minute_#{minute}"
    end

    private

    def keys_in_last_n_minutes(n)
      now = Time.current
      times = (0..n).collect { |n| now - n.minutes }
      times.collect{ |t| key(t.strftime("%M")) }
    end
  end

  # Tracking an Active
  def go_online
    key = current_key
    REDIS.sadd(key, self.id)
  end

  def go_offline
    
  end

  private

  def current_key
    self.class.key(Time.current.strftime("%M"))
  end
end