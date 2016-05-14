module SlackBot
  class Channel
    def initialize(info, bot)
      @data = info
      @bot = bot
    end
    
    def [](key)
      @data[key]
    end
    
    # Helpers!
    def creator
      @bot.user @data['creator']
    end
    def id; @data['id'] end
    def name; @data['name'] end
    def user; @bot.user @data['user'] end
    def channel?; @data['is_channel'] end
    def user_channel?; @data['is_im'] end
    def archived?; @data['is_archived'] end
    def members
      if user_channel?
        return [self.user]
      else
        return @data['members'].map { |id| @bot.user id }
      end
    end
    def purpose
      p = @data['purpose']
      p && p['value']
    end
    def topic
      p = @data['topic']
      p && p['value']
    end
    def session
      @bot.session.for_channel(self.id)
    end
    
    def to_s
      if user_channel?
        user.to_s
      else
        "##{name}"
      end
    end

    def post(message)
      @bot.post self, message
    end
  end
end
