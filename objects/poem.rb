#!/bin/env ruby
# encoding: utf-8

class Poem

  attr_accessor :templates
  attr_accessor :dictionary

	def generate q = nil

    @dict  = make_dict
    @query = q.to_s != "" ? q : nil

    p = nil
    c = 0
    c_t = 0
    while !p
      @usedWords = []
      if c % 20 == 0 then template = @templates.sample end
      if c > 200 then return "" end
      p = try(template)
      c += 1
      c_t += 1
    end

    return prettify(p)

  end

  def try template

    macros = template.scan(/(?:\{)([\w\W]*?)(?=\})/)
    targ_a = [(@query ? @query.strip.split(" ").first : findTarget),findTarget,findTarget,findTarget,findTarget]
    sign_a = [">","<",">","="].shuffle
    syll_a = [1,2,3,4].shuffle

    c = 0
    macros.each do |macro,v|
      type = macro[0,1].capitalize
      team = macro[1,1].to_i
      sign = team > 0 ? sign_a[team] : "?"
      targ = targ_a[team-1]
      syll = team > 0 ? syll_a[team] : nil
      word = findWord(type,sign,targ,syll)
      if !word then return nil end
      template = template.sub("{#{macro}}",word)
      @usedWords.push(word.downcase)
      c += 1
    end

    return template.strip

  end

  def findTarget

    word = nil
    while !word
      attempt = @dict["N"].sample
      word = attempt.length > 5 ? attempt : nil
    end
    return word

  end

  def findWord type, posi, target, syll

    @dict[type].shuffle.each do |word|
      if !word then next end
      if @usedWords.include?(word) then next end
      if syll && count_syllables(word) != syll then next end
      if word.length < 2 then next end
      if word.length > 9 then next end
      if posi == "=" && word == target then return word end
      if posi == "<" && word[0,3] == target[0,3] then return word end
      if posi == ">" && word[word.length-3,3] == target[target.length-3,3] then return word end
      if posi == "?" then return word end
    end

    return nil

  end

  def prettify p

    p = p.gsub("a a", "an a")
    p = p.gsub("a i", "an i")
    p = p.gsub("a u", "an u")
    p = p.gsub("a o", "an o")
    p = p.gsub("a e", "an e")

    p = p.gsub("sss","sses")
    p = p.gsub("shs","shes")
    # p = p.gsub!(/^\s*\w/){|match| match.upcase}

    p = p.gsub(";","\n")
    p = p.capitalize

    return p

  end

  def count_syllables target

    target = target.to_s.downcase
    return 1 if target.length <= 3
    target = target.sub(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
    target = target.sub(/^y/, '')
    return target.scan(/[aeiouy]{1,2}/).size

  end

  def make_dict

    word_type = ""

    dict = {}

    @dictionary.each do |line|
      word_type = line['C']
      if !dict[word_type] then dict[word_type] = [] end
      dict[word_type].push(line['WORD'])
    end

    return dict

  end

end