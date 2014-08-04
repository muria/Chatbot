require 'open-uri'
require 'cgi'

module Chatbot
  class UrbanDictionary
    include Cinch::Plugin

    HELPS << [":urban <word>", "search UrbanDictionary"]
  
    prefix Chatbot::PREFIX
    match /urban (.+)/

    def lookup(word, num=1)
      url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(word)}"
      html = open(url) 
      el = "div.meaning"
      doc = Nokogiri::HTML(html)
      total = doc.search(el)
      CGI.unescape_html doc.css(el)[num-1].text.gsub(/\s+/, ' ') rescue nil
    end

    def execute(m, word)
      args = word.match(/(.+)(\d)$/)
      unless args.nil?
        n = args[2].to_i     
        word = args[1].strip 
      end
      n ||= 1
      Util.bot_reply(m, "#{word}: #{(lookup(word, n) || 'No results found')}")
    end
  end
end
