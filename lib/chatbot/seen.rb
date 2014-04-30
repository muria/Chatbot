module Chatbot
  class Seen
    include Cinch::Plugin
    include Persistable

    HELPS << [":seen <nick>", "show when <nick> was last seen"]

    listen_to :channel, :join, :part, :quit, :nick
    prefix Chatbot::PREFIX
    match /seen (.+)/

    def initialize(*args)
      super

      @users = load || {}
    end

    def listen(m)
      return unless m.user
      nick = m.command == 'NICK' ? m.user.last_nick : m.user.nick

      @users[nick.downcase] = Event.new(nick, m.message, m.command, Time.now)
      save @users
    end

    def execute(message, str)
      str.split(/\s+/).each { |nick| check_nick(message, nick) }
    end

    private

    def check_nick(message, nick)
      if [@bot.nick.downcase, message.user.nick.downcase].include? nick.downcase
        Util.bot_reply(message, "Yes.")
      elsif @users.key? nick.downcase
        Util.bot_reply(message, @users[nick.downcase].to_s)
      else
        Util.bot_reply(message, "I haven't seen #{nick}.")
      end

    end

    class Event
      def initialize(nick, message, type, time)
        @nick    = nick
        @message = message
        @type    = type
        @time    = time
      end

      def to_s
        msg = "#{@nick} was last seen #{Util.distance_of_time_in_words @time} ago"

        case @type
        when 'JOIN'
          msg << ", joining."
        when 'PART'
          msg << ", leaving."
        when 'QUIT'
          msg << ", quitting."
        when 'NICK'
          msg << ", changing nick to #{@message}."
        else
          if @message =~ /^\001ACTION (.+?)\001/
            msg << ", saying '#{@nick} #{$1}'"
          else
            msg << ", saying '#{@message}'."
          end
        end
      end
    end

  end
end
