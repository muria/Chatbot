require 'cinch'
require "restclient"
require "nokogiri"
require "time"

module Chatbot
  PREFIX = ":"
  CHANNELS = Array(ENV['CHATBOT_CHANNEL'])
  HELPS = []
  NICK = "chatbot"
end

require 'chatbot/persistable'
require 'chatbot/util'

require 'chatbot/google'
require 'chatbot/history'
require 'chatbot/notes'
require 'chatbot/seen'
require 'chatbot/urban'
require 'chatbot/urls'
require 'chatbot/youtube'
