#!/bin/env ruby
# encoding: utf-8

$instance_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

$nataniev.require("action","tweet")

load_folder("#{$instance_path}/objects/*")

class Thewillthewisp

  include Vessel

  def twitter_account

    return "thewillthewisp"

  end

  def make_poem q = nil

    return Poem.new(q).to_s

  end

  # Actions

  class Actions

    include ActionCollection
    include ActionTweet

    def test q = nil

      return @actor.make_poem
      
    end

    def tweet_auto

      return tweet(@actor.make_poem)

    end

    def tweet_reply_auto

      last_reply  = last_replies.first
      username    = last_reply.user.screen_name
      target_word = last_reply.text.downcase.split(' ').last.gsub(/[^0-9a-z]/i, '')

      if username.like("thewillthewisp") then return "Repying to self." end
        
      # Check memory

      ra = Ra.new("memory",$instance_path)
      if ra.to_s == "#{username}:#{target_word}" then return "Already replied." end

      # Make Poem

      poem = @actor.make_poem(target_word)
      if poem.to_s == ""
        tweet_reply(last_reply,"@#{username} I cannot make you a rhyme from #{target_word}.",true)
      else
        tweet_reply(last_reply,"#{poem}\nThe #{target_word.capitalize}, for @#{username}.",true)
      end

      # Update memory
      ra.replace("#{username}:#{target_word}")
      return "Created poem: #{poem}"

    end

  end

  def actions ; return Actions.new(self,self) end

end