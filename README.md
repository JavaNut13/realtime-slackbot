# Realtime Slackbot

_Custom slackbots for everyone!_

Uses the realtime Slack API to read and respond to messages.

EG:

    require 'realtime-slackbot'

    class Bot < SlackBot::Bot
  
      # Called when a message is received on a channel this bot is in
      def message(msg)
        msg.reply("That was an insightful message")
      end
      
      # Every real time api call can be listened to by a function
      def user_change(data)
        # Called when a user_change notification is received on a watched channel
      end
    end

    key = 'xxxxxxxxxx'

    botbot = Bot.new(key, log: true)
    botbot.run

You can also just `include SlackBot` in any class to make it a slackbot.

There are some nifty matchers to make it easier to check and respond to messages:

    def message_matcher(matcher)
      matcher.before_match do |msg|
        msg['text'] = msg.text.gsub('“', '"').gsub('”', '"').gsub('‘', "'").gsub('’', "'")
      end
    
      matcher.when.match?(/(hey|hi) bot( ?bot)?/).then do |msg|
        msg.reply "Hey #{msg.user.pretty_first_name}"
      end
    end

This will be called to setup the matcher when the first `message` type notification is received. Subsequent messages will be processed with the matcher and the `then` action of the first successful match will be executed. `.before_match` will be called before any matching is done. In the above example I replace 'fancy quotes' with normal ones.

Like the notification methods, this can be used on any RTM notification, in the format `API_NAME_matcher`. However most of the matchers expect a `text` field, etc so they only work on _message_-messages. The matchers are:

+ `from?(username_or_id)`
+ `in?(channel_name_or_id)`
+ `include?(string)`
+ `match?(regex)`
+ `try? { |msg| ... }`

On success, either:

+ `then do ...`
+ `then_reply message_text`

## Install

Just run

    gem install realtime-slackbot

Or add to your Gemfile

    gem 'realtime-slackbot'

and run `bundle install`

You'll need to [create a bot user](https://api.slack.com/bot-users) for your slack team. Use the key on it's config page when you initialize the bot. Invite it to the slack channels you want it to hang out in.