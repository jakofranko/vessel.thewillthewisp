#!/bin/env ruby
# encoding: utf-8

$instance_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

class Willw

  include Vessel

  class PassiveActions

    include ActionCollection

    def answer q = nil

      load_folder("#{$instance_path}/objects/*")

      return Poem.new(q).to_s

    end

  end
  
  def passive_actions ; return PassiveActions.new(self,self) end

  class Actions

    include ActionCollection

    def auto t = nil

      require 'rubygems'
      require 'twitter'
      require "#{$nataniev.path}/secrets/secret.willwisp.config.rb"

      client = Twitter::REST::Client.new($twitter_config)
      client.search("to:thewillthewisp", :result_type => "recent").take(1).each do |tweet|

        target = tweet.text.downcase.split(' ').last.gsub(/[^0-9a-z]/i, '')

        ra = Ra.new("memory",$instance_path)

        if ra.to_s == tweet.id.to_s then break end
        if target.length < 4 then break end

        poem = $nataniev.answer("behol call willw #{target}")
        if poem.to_s == ""
          client.update("@#{tweet.user.screen_name} I cannot make you poem from #{target}.", in_reply_to_status_id: tweet.id)
        else
          client.update("#{poem}\nThe #{target.capitalize}, for @#{tweet.user.screen_name}.", in_reply_to_status_id: tweet.id)
          client.follow(tweet.user.screen_name)
        end
        
        ra.replace(tweet.id)

      end

      return "?"

    end

  end
  
  def actions ; return Actions.new(self,self) end

  # 

  def display q = nil

    return "- #{print.capitalize}, chirps a rhyme \"#{poem(q)}\".\n"

  end

end