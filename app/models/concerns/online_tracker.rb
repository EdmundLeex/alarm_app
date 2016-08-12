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

    def purge_buckets(keys)
      # call this in scheduler, invoke very ONLINE_MINUTE
      keys.each { |k| REDIS.del(k) }
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
    if REDIS.sadd(current_key, id)
      update_column(:online_key, current_key)
    end
  end

  def go_offline
    if REDIS.srem(online_key, id)
      update_column(:online_key, nil)
    end
  end

  def online?
    REDIS.smembers(online_key).include?(id.to_s)
  end

  private

  def current_key
    self.class.key(Time.current.strftime("%M"))
  end
end