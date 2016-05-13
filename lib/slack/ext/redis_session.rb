module SlackBot::Ext
  class RedisSession
    attr_reader :prefix
    
    def initialize(team_id, args={})
      @prefix = args[:prefix] || "team:#{team_id}:"
      @store = args[:store]
      @user_scoped = Hash.new
      @channel_scoped = Hash.new
    end

    def [](key)
      @store["#{@prefix}#{key}"]
    end

    def []=(key, val)
      @store["#{@prefix}#{key}"] = val
    end

    def for_user(id)
      @user_scoped[id] ||= RedisSession.new(nil, prefix: "#{@prefix}user:#{id}:", store: @store)
    end

    def for_channel(id)
      @channel_scoped[id] ||= RedisSession.new(nil, prefix: "#{@prefix}channel:#{id}:", store: @store)
    end
    
    def core
      @store
    end

    def to_s
      @store.to_s
    end
  end
end