require 'json'

module SlackBot
  class Message
    attr_reader :user
    
    def initialize(data, bot)
      @data = data
      @bot = bot
      @user = bot.user(data['user'])
    end
  
    def reply(text)
      @bot.post channel, text
    end
  
    def to_s
      "#{@user}: #{self.text}"
    end
  
    def [](key)
      @data[key]
    end
    
    def []=(key, val)
      @data[key] = val
    end
    
    # Helpers!
    def id; @data['id'] end
    def text; @data['text'] end
    def time
      ts = @data['ts']
      ts && Time.at(ts.to_i)
    end
    def channel
      chan = @data['channel']
      @bot.channel(chan) || @bot.user_channel(chan)
    end
  end
end