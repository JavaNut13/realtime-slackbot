class SlackBot::Matcher
  def initialize(msg)
    @message = msg
    @passing = true
  end
  
  def from?(user)
    return self unless @passing
    user = user.to_s.downcase
    if @user
      if @user.id == user || @user.name.downcase == user
        res = true
      else
        real = @user.real_name
        res = real == user || real.split(' ').map { |n| user == n }.any?
      end
    else
      res = false
    end
    @passing &&= res
    self
  end
  
  def in?(options={})
    return self unless @passing
    res = false
    if options[:id]
      res = @message['channel'] == options[:id]
    elsif options[:name]
      chans = @bot.team_info['channels'].select { |name| ch[id] == channel }
      res = chans.first == options[:name]
    end
    @passing &&= res
    self
  end
  
  def include?(text)
    return self unless @passing
    @passing &&= @message['text'].downcase.include? text
    self
  end
  
  def match?(reg)
    return self unless @passing
    @passing &&= @message['text'].downcase.match reg
    self
  end
  
  def then(&block)
    block.call if @passing
  end
  
  def then_reply(*args)
    if @passing
      @message.reply(*args)
    end
  end
end