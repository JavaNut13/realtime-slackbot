module SlackBot
  class Session
    def initialize
      @user_scoped = Hash.new
      @channel_scoped = Hash.new
      @general = Hash.new
    end

    def [](key)
      @general[key]
    end

    def []=(key, val)
      @general[key] = val
    end

    def for_user(id)
      @user_scoped[id] ||= Hash.new
    end

    def for_channel(id)
      @channel_scoped[id] ||= Hash.new
    end

    def to_s
      @general.to_s
    end
  end
end
