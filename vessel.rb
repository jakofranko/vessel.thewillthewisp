#!/bin/env ruby
# encoding: utf-8

$nataniev.require("action","tweet")

class VesselThewillthewisp

  include Vessel

  def initialize id = 0

    super

    @name = "The Will & The Wisp"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "Poem generating silver beetle bot."
    @site = "http://wiki.xxiivv.com/the+will+the+wisp"

    install(:custom,:generate)
    install(:custom,:tweet)
    install(:generic,:document)
    install(:generic,:help)

  end

end

class ActionGenerate

  include Action

  def initialize q = nil

    super

    @name = "Generate"
    @docs = "Create a poem."

  end

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

  include Action

  def initialize q = nil

    super

    @name = "Tweet"
    @docs = "Share poem to [@#{account}](https://twitter.com/#{account})."

  end

  def account

    return "thewillthewisp"

  end

  def payload

    return ActionGenerate.new(@host).act

  end

end