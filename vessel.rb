#!/bin/env ruby
# encoding: utf-8

$nataniev.require("action","tweet")

class VesselThewillthewisp

  include Vessel

  def initialize id = 0

    super

    @name    = "The Will & The Wisp"
    @path    = File.expand_path(File.join(File.dirname(__FILE__), "/"))

    install(:default,:generate)
    install(:default,:tweet)

  end

end

class ActionGenerate

  include Action

  def act q = nil

    load "#{@host.path}/objects/poem.rb"

    templates  = Memory_Array.new("templates",@host.path).to_a
    dictionary = Memory_Array.new("dictionary").to_a

    poem = Poem.new
    poem.templates = templates
    poem.dictionary = dictionary
    
    return poem.generate(q)

  end

end

class ActionTweet

  def account

    return "thewillthewisp"

  end

  def payload

    return ActionGenerate.new(@host).act

  end

end