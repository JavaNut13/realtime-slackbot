require 'json'
require_relative 'matchers/matcher'

module SlackBot
  class Message
    attr_accessor :user
  
    def initialize(data, bot)
      @data = data
      @bot = bot
      @user = bot.user(data['user'])
    end
  
    def reply(text)
      @bot.post channel, text
    end
  
    def to_s
      "#{@user.name}: #{@data['text']}"
    end
    
    def user
      @bot.user(@data['user'])
    end
  
    def [](key)
      @data[key]
    end
    
    def []=(key, val)
      @data[key] = val
    end
  
    def method_missing(name, *args)
      # Access data if no args and is valid key, else throw exception
      if args.count == 0 && @data.has_key?(name.to_s)
        @data[name.to_s]
      else
        super(name, args)
      end
    end
  end
end