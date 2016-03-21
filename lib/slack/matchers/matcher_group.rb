require_relative 'matcher'

module SlackBot
  class MatcherGroup
    def initialize(action)
      @action = action
      @matchers = []
    end

    def respond_for(msg)
      @before_match.call(msg) if @before_match
      @matchers.each do |m|
        break if m.run_on(msg)
      end
    end
    
    def when
      m = Matcher.new
      @matchers.push m
      return m
    end
    
    def before_match(&block)
      @before_match = block
    end
    
    def to_s
      "#{@action} #{@matchers.count}"
    end
  end
end