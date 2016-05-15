module SlackBot
  module Helpers
    def channels
      @channels ||= load_channels
    end
  
    def channel(id)
      channels[id]
    end
   
    def user_channels
      @user_channels ||= load_user_channels
    end
  
    def user_channel(user)
      if user.is_a? User
        id = user.id
      else
        id = user
      end
      user_channels[id]
    end
  
    def users
      @users ||= load_users
    end
  
    def user(id)
      users[id]
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
  end
end
