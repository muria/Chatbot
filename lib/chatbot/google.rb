require 'uri'
require 'json'

module Chatbot
  class Google
    include Cinch::Plugin

    HELPS << [":g|google", "search Google"]

    prefix Chatbot::PREFIX
    match /(?:g|google) (.+)/


    def execute(message, query)
      resp   = JSON.parse(RestClient.get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{URI.escape query}"))
      result = resp.fetch('responseData').fetch('results').first

      if result
        Util.bot_reply(message, "#{result['titleNoFormatting']}: #{result['url']}")
      else
        Util.bot_reply(message, "No results.")
      end
    rescue => e
      Util.bot_reply(message, e.message)
    end

  end # Google
end # Chatbot

