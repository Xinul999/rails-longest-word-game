require 'open-uri'

class GamesController < ApplicationController
  def new
    @str = ''
    (0...10).each do |num|
      @str += if num.even?
                'AEIOUY'.at(rand(6))
              else
                'BCDFGHJKLMNPQRSTVWXZ'.at(rand(20))
              end
    end
  end

  def score
    letters_input = params[:letters]
    letters_games = params[:letters_hidden]
    @score = checker(letters_games, letters_input)
  end

  private

  def checker(letters_games, letters_input)
    commas = letters_games.chars.split(' ').join(',')
    error_msg = "Sorry but #{letters_input} can't build out of #{commas}"
    if letters_ok?(letters_games, letters_input) == false
      @msg = error_msg
    else
      ret = check_api(letters_input)
      @msg = if ret.zero?
               error_msg
             else
               "Congratulation! #{letters_input} give you a score of #{ret} point(s)"
             end
    end
  end

  def letters_ok?(letters, input)
    i = 0
    ok = true
    while i < input.length && ok
      ok = false unless letters.include?(input[i].upcase)
      i += 1
    end
    ok
  end

  def check_api(letters_input)
    url = "https://wagon-dictionary.herokuapp.com/#{letters_input}"
    response_data = JSON.parse(URI.open(url).read)
    puts response_data
    state = response_data['found']
    puts "state : #{state} => #{state.class}"
    if state
      response_data['length']
    else
      0
    end
  end
end
