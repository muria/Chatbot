require "uri"

module Chatbot
  class Urls
    include Cinch::Plugin
    include Persistable

    HELPS << [":url", "show the last 10 urls"]
    MAX_URLS = 10

    listen_to :channel
    prefix Chatbot::PREFIX

    match /url/

    def initialize(*args)
      super
      @url = load || {}
    end

    def execute(message)
      unless @url.empty?
        (@url.keys[-MAX_URLS..-1] || @url.keys[-@url.length..-1]).reverse_each { |uri|
          message.user.privmsg @url[uri].to_s
        }
      end
    end

    def listen(m)
      return unless m.user
      nick = m.command == 'NICK' ? m.user.last_nick : m.user.nick

      URI::extract(m.message, ["http", "https", "ftp", "mailto", "ftps"]).each { |u|
        
        e = Util::Event.new(nick, u, nil, Time.now)
        @url[Time.now] = e.to_s
        save @url
        
      } 
      
    end

  end
end
