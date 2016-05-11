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
    def channel?; @data['is_channel'] end
    def archived?; @data['is_archived'] end
    def members
      @data['members'].map do |id|
        @bot.user id
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
  end
end