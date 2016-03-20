require 'json'
require_relative 'matcher'

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
  
    def [](key)
      @data[key]
    end
    
    def []=(key, val)
      @data[key] = val
    end
  
    def method_missing(name, *args)
      if Matcher.instance_methods.include? name.to_sym
        return Matcher.new(self).send(name, *args)
      else
        @data[name.to_s]
      end
    end
  end
end