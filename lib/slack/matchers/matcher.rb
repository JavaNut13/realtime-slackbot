class SlackBot::Matcher
  def initialize
    @tests = []
    @finally = nil
  end
  
  def run_on(msg)
    @tests.each do |test|
      unless test.call(msg)
        return false
      end
    end
    @finally.call(msg) if @finally
    return true
  end
  
  def from?(user)
    @tests << Proc.new do |msg|
      user = user.to_s.downcase
      msg_user = msg.user.id
      return false unless msg_user
      if msg_user.id == user || msg_user.name.downcase == user
        return true
      else
        real = msg_user.real_name
        return real == user || real.split(' ').map { |n| user == n }.any?
      end
    end
    self
  end
  
  def in?(options={})
    @tests << Proc.new do |msg|
      if options[:id]
        return msg.channel == options[:id]
      elsif options[:name]
        chans = msg.bot.team_info['channels'].select { |name| ch[id] == channel }
        return chans.first == options[:name]
      end
    end
    self
  end
  
  def include?(text)
    @tests << Proc.new do |msg|
      msg.text.downcase.include? text
    end
    self
  end
  
  def match?(reg)
    @tests << Proc.new { |msg| msg.text.downcase.match reg }
    self
  end
  
  def then(&block)
    @finally = block
  end
  
  def then_reply(*args)
    @finally = Proc.new do |msg|
      msg.reply(*args)
    end
  end
end