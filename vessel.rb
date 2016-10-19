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

  # 

  def display q = nil

    return "- #{print.capitalize}, chirps a rhyme \"#{poem(q)}\".\n"

  end

end