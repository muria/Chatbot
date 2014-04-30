require 'open-uri'
require 'cgi'

module Chatbot
  class UrbanDictionary
    include Cinch::Plugin

    HELPS << [":urban <word>", "search UrbanDictionary"]
  
    prefix Chatbot::PREFIX
    match /urban (.+)/

    def lookup(word)
      url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(word)}"
      CGI.unescape_html Nokogiri::HTML(open(url)).at("div.definition").text.gsub(/\s+/, ' ') rescue nil
    end

    def execute(m, word)
      Util.bot_reply(m, "#{word}: #{(lookup(word) || 'No results found')}")
    end
  end
end
