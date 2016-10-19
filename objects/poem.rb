#!/bin/env ruby
# encoding: utf-8

class Poem

	def initialize q = nil

		@query = q.to_s.strip == "" ? nil : q

	end

	def to_s

    @templates = Ra.new("templates",$instance_path).to_a
    @dict      = make_dict

    p = nil
    c = 0
    while !p
      puts "Try #{c}"
      @usedWords = []
      if c > 20 then targetTemplate = @templates.sample ; c = 0 end
      p = generate(@templates.sample)
      c += 1
    end

    p = p.gsub("A o", "An o")
    p = p.gsub("A a", "An a")
    p = p.gsub("A u", "An u")
    p = p.gsub("A e", "An e")
    p = p.gsub("A i", "An i")

    p = p.gsub("a a", "an a")
    p = p.gsub("a i", "an i")
    p = p.gsub("a u", "an u")
    p = p.gsub("a o", "an o")
    p = p.gsub("a e", "an e")

    p = p.gsub("a A", "an A")
    p = p.gsub("a I", "an I")
    p = p.gsub("a U", "an U")
    p = p.gsub("a O", "an O")
    p = p.gsub("a E", "an E")

    p = p.gsub("A A", "An A")
    p = p.gsub("A I", "An I")
    p = p.gsub("A U", "An U")
    p = p.gsub("A O", "An O")
    p = p.gsub("A E", "An E")

    p = p.gsub("a ha", "an ha")
    p = p.gsub("sss","ses")
    p = p.gsub!(/^\s*\w/){|match| match.upcase}

    return p

  end

  def generate template

    macros = template.scan(/(?:\{)([\w\W]*?)(?=\})/)

    targ = [(@query ? @query.strip.split(" ").first : findTarget),findTarget,findTarget,findTarget,findTarget]
    
    macros.each do |macro,v|

      type = macro[0,1]
      posi = macro[1,1]
      team = macro[2,1].to_i
      capi = type.capitalize == type ? true : false

      game = findWord(type,posi,targ[team-1])
      if game == nil then return nil end
      game = capi == true ? game.capitalize : game
      @usedWords.push(game.downcase)

      template = template.sub("{#{macro}}",game)

    end

    return template.strip

  end

  def findTarget

    word = nil
    while !word
      attempt = @dict["NOUN"].sample
      word = attempt.length > 5 ? attempt : nil
    end
    return word

  end

  def findWord type, posi, target

    if    type.downcase == "n" then type_name = "NOUN"
    elsif type.downcase == "v" then type_name = "VERB"
    elsif type.downcase == "a" then type_name = "ADJ"
    elsif type.downcase == "i" then type_name = "INTERROG"
    elsif type.downcase == "p" then type_name = "PREP"
    elsif type.downcase == "m" then type_name = "POSS"
    elsif type.downcase == "d" then type_name = "ADV"
    elsif type.downcase == "i" then type_name = "INTERROG"
    else return nil end

    @dict[type_name].shuffle.each do |word|
      if !word then next end
      if @usedWords.include?(word) then next end
      if word.length < 4 then next end
      if word.length > 9 then next end
      if posi == "=" && word == target then return word end
      if posi == "<" && word[0,3] == target[0,3] then return word end
      if posi == ">" && word[word.length-3,3] == target[target.length-3,3] then return word end
      if posi == "?" then return word end
    end

    return nil

  end

  def make_dict

    word_type = ""

    dict = {}

    File.open("#{$nataniev.path}/library/dictionary.en","r:UTF-8") do |f|
      f.each_line do |line|
        depth = line[/\A */].size
        line = line.strip
        if depth == 0
          word_type = line
        else
          if !dict[word_type] then dict[word_type] = [] end
          dict[word_type].push(line)
        end
      end
    end

    return dict

  end

end