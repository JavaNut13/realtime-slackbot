module SlackBot
  module Helpers
    def channels(query=nil)
      @channels ||= load_channels
      if query == nil
        @channels.values
      else
        search(:all, @channels.values, query)
      end
    end
  
    def channel(id)
      if id.is_a? Hash
        search(:first, channels, id)
      else
        @channels ||= load_channels
        @channels[id]
      end
    end
   
    def user_channels(query=nil)
      @user_channels ||= load_user_channels
      if query == nil
        @user_channels.values
      else
        search(:all, @user_channels.values, query)
      end
    end
  
    def user_channel(user)
      if user.is_a? Hash
        search(:first, user_channels, user)
      else
        if user.is_a? User
          user = user.id
        end
        @user_channels ||= load_user_channels
        @user_channels[user]
      end
    end
    
    def users(query=nil)
      @users ||= load_users
      if query == nil
        @users.values
      else
        search(:all, @users.values, query)
      end
    end
  
    def user(id)
      if id.is_a? Hash
        search(:first, users, id)
      else
        @users ||= load_users
        @users[id]
      end
    end
  
    def me
      @me ||= user(@team_info['self']['id'])
    end
  
    def [](key)
      @team_info[key]
    end

    private
    def load_channels
      channels = Hash.new
      @team_info['channels'].each do |chan|
        channels[chan['id']] = Channel.new chan, self
      end
      channels
    end
 
    def load_user_channels
      channels = Hash.new
      @team_info['ims'].each do |chan|
        channels[chan['user']] = Channel.new chan, self
      end
      channels
    end

    def load_users
      users = Hash.new
      (@team_info['users'] + @team_info['bots']).map do |info| 
        users[info['id']] = User.new info, self
      end
      users
    end
    
    def search(type, array, query)
      res = []
      array.each do |value|
        matches = query.map do |key, test|
          if test.is_a? Regexp
            !!test.match(value[key.to_s])
          elsif test.is_a? Proc
            test.call(value[key.to_s])
          elsif test.respond_to? :id # For users, channels, etc
            value[key.to_s] == test.id
          else
            test == value[key.to_s]
          end
        end
        if matches.all?
          res.push value
        end
        if type == :first && res.count >= 1
          return res.first
        end
      end
      return type == :first ? res.first : res
    end
  end
end
