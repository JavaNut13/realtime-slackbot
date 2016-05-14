require_relative 'wrappers/user'
require_relative 'wrappers/message'
require_relative 'wrappers/channel'
require_relative 'session'
require_relative 'matchers/matcher_group'
require_relative 'helpers'
require 'net/http'
require 'faye/websocket'
require 'eventmachine'
require 'json'

module SlackBot
  SLACK_AUTH_URL = 'https://slack.com/api/rtm.start?token='
  attr_accessor :socket
  attr_writer :debug
  attr_reader :team_info
  attr_reader :session
  attr_accessor :auth_url
  
  def initialize(auth_key, options={})
    setup(options)
    @key = auth_key.strip
  end
  
  def setup(options={})
    @debug = options[:log]
    @matchers = Hash.new
    if options[:session]
      @session_type = options[:session].delete(:use)
      @session_args = options[:session]
    else
      @session_type = Session
      @session_args = {}
    end
    @auth_url = SLACK_AUTH_URL
  end
  
  def get_url
    data = Net::HTTP.get(URI(@auth_url + @key))
    json = JSON.parse(data)
    @team_info = json
    if json['ok']
      return json['url']
    else
      raise "ERROR: #{json.to_s}"
    end
  end
  
  def run
    url = get_url()
    EM.run do
      @socket = ws = Faye::WebSocket::Client.new(url)

      ws.on :open do |event|
        log(:open, event.to_s)
        create_session(team_info['team']['id'])
        hook(:opened)
      end

      ws.on :message do |event|
        log(:action, event.data)
        begin
          json = JSON.parse(event.data)
          type = json.delete('type')
          if type
            message = Message.new(json, self)
            unless type == "message" && message.user == me
              hook(type, message)
            end
          else
            hook(:unknown, json)
          end
        rescue JSON::ParserError => e
          log(:error, e.message)
        end
        
      end

      ws.on :close do |event|
        log(:close, "#{event.code} #{event.reason}")
        @socket = ws = nil
        hook(:closed)
        EM.stop
      end
    end
  end
  
  def post(channel, message)
    if channel.is_a? String
      chan = channel
    elsif channel.is_a? Channel
      chan = channel.id
    else
      raise "Not a valid channel: #{channel}"
    end
    data = {
      id: 1,
      type: 'message',
      channel: chan,
      text: message.to_s
    }
    @socket.send data.to_json
  end
  
  def reply_to(msg, text)
    post(msg['channel'], text)
  end
  
  def log(type, message)
    if debug?
      puts "#{type}: #{message}"
    end
  end
  
  def debug?
    @debug
  end

  private
  def hook(action, *args)
    if self.respond_to? "#{action}_matcher"
      unless @matchers.has_key? action
        matcher_group = MatcherGroup.new(action)
        self.send("#{action}_matcher", matcher_group)
        @matchers[action] = matcher_group
      end
      begin
        @matchers[action].respond_for(args.first)
      rescue Exception => e
        puts e.message
        puts e.backtrace.join "\n"
      end
    elsif self.respond_to? action
      begin
        send(action, *args)
      rescue Exception => e
        puts e.message
        puts e.backtrace.join "\n"
      end
    end
  end
  
  def create_session(team_id)
    @session = @session_type.new(team_id, @session_args)
  end
end
