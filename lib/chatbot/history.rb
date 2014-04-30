module Chatbot
  class History
    include Cinch::Plugin

    listen_to :channel, :join, :part, :quit, :nick

    def listen(m)
      return unless m.user
      nick = m.command == 'NICK' ? m.user.last_nick : m.user.nick
      e = Util::Event.new(nick, m.message, m.command, Time.now)
      Util.save_event(e)
    end

  end

end
