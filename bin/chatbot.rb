#!/usr/bin/env ruby

require 'chatbot'

Cinch::Bot.new {
  configure do |c|
    c.server = "irc.freenode.net"
    c.nick   = Chatbot::NICK
    c.channels = Chatbot::CHANNELS
    c.plugins.plugins = [
      Chatbot::Google,
      Chatbot::History,
      Chatbot::Notes,
      Chatbot::Seen,
      Chatbot::UrbanDictionary,
      Chatbot::Urls,
      Chatbot::Youtube,
    ]
  end

  Chatbot::HELPS << [':help', "you're looking at it"]
  on :message, /:help/ do |m|
    helps = Chatbot::HELPS.sort_by { |e| e[0] }
    just = helps.map { |e| e[0].length }.max

    helps.each do |command, help|
      m.user.privmsg "#{command.ljust just} - #{help}"
    end
  end

  [
    {
      :expression => /:gist/,
      :text       => "Please paste >3 lines of text to https://gist.github.com",
      :help       => "link to gist.github.com",
    },
    {
      :expression => /:(gist-?usage|using-?gist)/,
      :text       => "https://github.com/radar/guides/blob/master/using-gist.markdown",
      :help       => "how to use gists",
    },
    {
      :expression => /:ask/,
      :text       => "If you have a question, please just ask it. Don't look for topic experts. Don't ask to ask. Don't PM. Don't ask if people are awake, or in the mood to help. Just ask the question straight out, and stick around. We'll get to it eventually :)",
      :help       => "Don't ask to ask."
    },
    {
      :expression => /:clarify/,
      :text       => "I'm not sure what you're talking about.  Please clarify.",
      :help       => "Please clarify your question."
    },
    {
      :expression => /:(kittens?|cats?)/,
      :text       => "Think of the kittens!",
      :help       => "It's all about cats!"
    },
    {
      :expression => /:(puppy|puppies|dogs?)/,
      :text       => "Think of the puppies!",
      :help       => "It's all about dogs!"
    }
  ].each do |cmd|
    Chatbot::HELPS << [cmd[:expression].source, cmd[:help]]
    on(:message, cmd[:expression]) { |m| m.reply cmd[:text] }
  end

}.start

