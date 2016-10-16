#!/bin/env ruby
# encoding: utf-8

class Willw

  include Vessel

  class PassiveActions

    include ActionCollection

    def answer q = "Home"

      path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

      load_folder("#{path}/objects/*")

      return Poem.new(path).to_s

    end

  end
  
  def passive_actions ; return PassiveActions.new(self,self) end

  # 

  def display q = nil

    return "- #{print.capitalize}, chirps a rhyme \"#{poem(q)}\".\n"

  end

end