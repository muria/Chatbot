module Chatbot
  class Youtube
    include Cinch::Plugin

    HELPS << [":yt|youtube", "search YouTube"]

    prefix Chatbot::PREFIX
    match /(?:yt|youtube) (.+)/

    def execute(message, query)
      xml = RestClient.get "http://gdata.youtube.com/feeds/api/videos?q=#{escaper.escape query}&max-results=1&v=2"
      doc = Nokogiri.XML(xml)

      Util.bot_reply(message, Video.new(doc.css("entry").first).reply)
    end

    def escaper
      @escaper ||= URI::Parser.new
    end

    class Video
      def initialize(doc)
        @doc = doc
      end

      def url
        @doc.css("link[rel=alternate]").first['href']
      end

      def title
        @doc.css("title").text
      end

      def reply
        "#{title} - #{url}"
      end
    end

  end # Youtube
end # Chatbot
