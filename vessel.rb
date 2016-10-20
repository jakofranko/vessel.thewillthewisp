#!/bin/env ruby
# encoding: utf-8

$instance_path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

load_folder("#{$instance_path}/objects/*")

class Willw

  include Vessel

  class PassiveActions

    include ActionCollection

    def answer q = nil

      return Poem.new(q).to_s

    end

  end
  
  def passive_actions ; return PassiveActions.new(self,self) end

  def poem_for username,word

    poem = Poem.new(word).to_s

    if poem.to_s == "" then return "@#{username} I cannot make you a rhyme from #{word}." end

    ra = Ra.new("memory",$instance_path)
    if ra.to_s == "#{username}:#{word}" then return nil end

    ra.replace("#{username}:#{word}")

    return "#{poem}\nThe #{word.capitalize}, for @#{username}."

  end

  # 

  def display q = nil

    return "- #{print.capitalize}, chirps a rhyme \"#{poem(q)}\".\n"

  end

end