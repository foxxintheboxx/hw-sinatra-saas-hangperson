class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @word_with_guesses = "-" * self.word.length
  end
  
  def append_wrong_guess(character)
    if self.wrong_guesses().include?(character) == false
      self.wrong_guesses= (self.wrong_guesses + character)
      return true
    else
      return false
    end
  end
  
  
  def fill_character(character)
    for pos in 0..self.word_with_guesses.length - 1
        if character == self.word[pos]
          self.word_with_guesses[pos] = character
        end
    end
  end

  def append_guess(character)
    if self.guesses().include?(character) == false
      self.guesses= (self.guesses + character)
      self.fill_character(character)
      return true
    else
      return false
    end
  end
   
  def guess (character)
    if (character != nil and character.length == 1 and  \
          (character.downcase == character.downcase[/[a-z]/]))
      character = character.downcase
      if self.word.include? character
        return self.append_guess(character)
      else
        return self.append_wrong_guess(character)
      end
    else
      return raise ArgumentError.new
    end
  end
  
  def check_win_or_lose
    if self.guesses.length == self.word.length
      return :win
    elsif self.wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
      
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
