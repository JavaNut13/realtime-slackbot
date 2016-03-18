# Realtime Slackbot

_Custom slackbots for everyone!_

Uses the realtime Slack API to read and respond to messages.

EG:

    require 'realtime-slackbot'

    class Bot < SlackBot::Bot
  
      # Called when a message is received on a channel this bot is in
      def message(msg)
        msg.match?(/(hey|hi) bot( ?bot)?/).then_reply "Hey #{msg.user.pretty_first_name}"
    
        msg.match?(/introduce yourself/).match?(/bot ?bot/).then_reply "Hi @everybody, I'm a robot!"
    
        msg.match?(/^thanks.*? bot( ?bot)?/).then do
          name = msg.user.pretty_first_name
          msg.reply "You're welcome #{name}"
        end
      end
      
      def user_change(data)
        # Called when a user_change notification is received on a watched channel
      end
    end

    key = 'xxxxxxxxxx'

    botbot = Bot.new(key, log: true)
    botbot.run

You can also just `include SlackBot` in any class to make it a slackbot.

## Install

Just run

    gem install realtime-slackbot

Or add to your Gemfile

    gem 'realtime-slackbot'

and run `bundle install`

You'll need to [create a bot user](https://api.slack.com/bot-users) for your slack team. Use the key on it's config page when you initialize the bot. Invite it to the slack channels you want it to hang out in.