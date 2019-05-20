require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:word].upcase
    @grid = params[:grid]
    @result = score_and_message(@guess, @grid)
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def score_and_message(attempt, grid)
    if included?(@guess, @grid)
      if english_word?(@guess)
        # score = compute_score(attempt, time)
        'Well done'
      else
        'Not an english word'
      end
    else
      'Not in the grid'
    end
  end
end
