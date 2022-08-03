# frozen_string_literal: true

require 'yaml'

require_relative 'display'
require_relative 'save_logic'

class Game
  attr_reader :word, :available_letters, :correct_letters, :wrong_letters

  include Display
  include SaveLogic

  def initialize
    @available_letters = ('a'..'z').to_a
    @correct_letters = []
    @wrong_letters = []

    @loaded_save_name = nil

    play_game
  end

  def play_game
    puts display_menu

    option = option_selection
    new_game if option == '1'
    load_game if option == '2'
    puts display_game('goodbye') if option == '3'
  end

  def option_selection
    print display_select_option('main_menu')
    option = gets.chomp
    option.match(/^[1-3]$/) ? (return option) : puts(display_invalid('option'))

    option_selection
  end

  def new_game
    @word = select_random_word
    @solution = word.split('')
    @solution.each { correct_letters.push('_') }

    @lives = select_difficulty

    player_turns('new_game')
    end_game
  end

  def select_random_word
    words_list = File.readlines('words_list.txt', chomp: true)
    words_list.select! { |word| word.length.between?(5, 12) }
    words_list[rand(0..words_list.length)]
  end

  def select_difficulty
    puts display_difficulty_menu
    print display_select_option('main_menu')

    difficulty = gets.chomp
    return 6 if difficulty.match(/^1$/)
    return 8 if difficulty.match(/^2$/)
    return 10 if difficulty.match(/^3$/)

    puts display_invalid('option')
    select_difficulty
  end

  def player_turns(type)
    @lives_left = @lives - wrong_letters.length
    while @lives_left != 0
      puts display_game_instructions(type)
      puts display_game('correct_letters')

      break if player_won?(correct_letters) == 'won'

      @player_guess = turns_option_selection
      break if @player_guess.length > 1

      solution_has_letter?
    end
    save_game if @player_guess == 'save'
  end

  def turns_option_selection
    print display_select_option('turns_menu')
    option = gets.chomp.downcase

    return option if valid_guess?(option)

    puts display_invalid('guess') unless available_letters.include?(@player_guess)
    turns_option_selection
  end

  def solution_has_letter?
    @solution.each_with_index do |letter, index|
      correct_letters[index] = @player_guess if @player_guess == letter
    end

    if !@solution.include?(@player_guess)
      @lives_left -= 1
      wrong_letters.push(@player_guess) unless wrong_letters.include?(@player_guess)
    end
  end

  def valid_guess?(guess)
    if guess.match(/^[a-z]$/) && available_letters.include?(guess)
      available_letters.delete(guess)
      true
    elsif guess.match(/^save$|^exit$/)
      true
    end
  end

  def player_won?(final_solution)
    return 'not_defined' if @lives_left != 0 && final_solution.include?('_')
    return 'won' if @lives_left != 0 && !final_solution.include?('_')
    return 'lose' if @lives_left.zero?
  end

  def end_game
    result = player_won?(correct_letters)
    puts display_game(result) if result.match(/^won$|^lose$/)

    endgame_delete_save if result != 'not_defined' && @loaded_save_name

    print display_game('play_again?')
    option = gets.chomp

    return Game.new if option.match(/y/i)

    puts display_game('goodbye')
  end
end

Game.new
