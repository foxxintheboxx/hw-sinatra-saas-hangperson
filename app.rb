require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
    if session[:guesses]
      @game.guesses=(session[:guesses])
    end
    if session[:word]
      @game.word=(session[:word])
    end
    if session[:wrong_guesses]
      @game.wrong_guesses=(session[:wrong_guesses])
    end
    guesses = self.word_with_guesses(@game.word, @game.guesses)
    @game.word_with_guesses=(guesses)
  end
  
  after do
    session[:word] = @game.word
    session[:guesses] = @game.guesses
    session[:wrong_guesses] = @game.wrong_guesses
    session[:word_with_guesses] = @game.word_with_guesses
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ###
    puts("guess")
    begin 
      if not @game.guess(letter)
        flash[:message] = "You have already used that letter."
      end
    rescue ArgumentError
       flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    puts(@game.check_win_or_lose)
    puts(@game.word)
    puts(@game.word_with_guesses)
    if @game.check_win_or_lose == :play
      erb :show
    elsif @game.check_win_or_lose == :win
      redirect '/win'
    else
      redirect '/lose'
    end
  end
  
  get '/win' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :win
      erb :win # You may change/remove this line
    else
      redirect '/new'
    end
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :lose
      erb :lose # You may change/remove this line
    else
      redirect '/new'
    end
  end


  
  def word_with_guesses(word, character)
    word_with_guesses = "-" * word.length
    character.split("").each do | char |
      for pos in 0..word.length - 1
          if char == word[pos]
            word_with_guesses[pos] = char
          end
      end
    end
    word_with_guesses
  end
  
end
