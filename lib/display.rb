# frozen_string_literal: true

module Display
  def formatting(type, string)
    {
      'bold' => "\e[1m#{string}\e[0m",
      'bold_red' => "\e[31;1m#{string}\e[0m",
      'bold_blue' => "\e[34;1m#{string}\e[0m",
      'bold_green' => "\e[32;1m#{string}\e[0m",
      'bold_yellow' => "\e[33;1m#{string}\e[0m",
      'bold_underline' => "\e[4;1m#{string}\e[0m",
    }[type]
  end

  def display_select_option(type)
    {
      'main_menu' => "\n#{formatting('bold_yellow', '<?>')} Option: ",
      'turns_menu' => "\n#{formatting('bold_yellow', '<?>')} Shot a letter guess, #{formatting('bold', "'save' or 'exit'")} to quit the game: "
    }[type]
  end

  def display_invalid(type)
    {
      'guess' => "#{formatting('bold_red', '<!>')} Already tried this letter or it's invalid!",
      'option' => "#{formatting('bold_red', '<!>')} Invalid Option!",
      'save_name' => "#{formatting('bold_red', '<!>')} This save name is already taken! Try another one.",
      'selected_save' => "#{formatting('bold_red', '<!>')} This save doesn't exist!."
    }[type]
  end

  def display_game(type)
    {
      'won' => formatting('bold_green', '|| You won!'),
      'lose' => "#{formatting('bold_red', '|| You lose!')} The random word was #{formatting('bold_red', word)}.",
      'saved_name' => "\n#{formatting('bold_green', '<!>')} Saved as #{@filename}.\n\n",
      'inform_save_name' => "\n#{formatting('bold_yellow', '<?>')} Please, inform a name for your save name: ",
      'select_save_name' => "\n#{formatting('bold_yellow', '<?>')} Please, inform your save name (without the '.yaml') or 'r'eturn: ",
      'loading' => formatting('bold_green', "\n<!> Loading save..."),
      'play_again?' => formatting('bold', "<> Play again? 'y'es or any key for no: "),
      'correct_letters' => formatting('bold', "<> #{correct_letters.join(' ')}"),
      'goodbye' => formatting('bold_underline', "\nThank you for playing the Hangman game, see you!\n\n")
    }[type]
  end

  def display_menu_instructions
    system 'clear'

    <<~INSTRUCTIONS
      <>
      || Welcome to the Hangman game!
      ||
      || How to play Hangman in the console.
      || A random word will be chosen. On each turn, you can guess one letter.
      || To win, you must find all the letters in the word before using 8 incorrect guesses.
    INSTRUCTIONS
  end

  def display_menu
    <<~MENU
      <>
      || 1. New Game
      || 2. Load Game
      || 3. Exit
      <>
    MENU
  end

  def display_game_instructions(type, word)
    system 'clear'

    if type == 'new_game'
      <<~INSTRUCTIONS
        <>
        || Welcome player! This is a new game.
        ||
        || Your #{formatting('bold_blue', "random word")} has been chosen, it has #{formatting('bold_blue', "#{@solution.length} letters")}.
        || You have #{formatting('bold_red', @guesses_left)} guess(es) left. Wrong guesses: #{formatting('bold_red', wrong_letters.join(', '))}.
        <>

      INSTRUCTIONS
      # Paste this two lines below after line 78 if you want to see what's the random word in game
      # || This game's word is #{formatting('bold_blue', word)}.
      # <>
    elsif type == 'load_game'
      <<~INSTRUCTIONS
        <>
        || Welcome player! You loaded a game.
        ||
        || Your #{formatting('bold_blue', "random word")} has been chosen, it has #{formatting('bold_blue', "#{@solution.length} letters")}.
        || You have #{formatting('bold_red', @guesses_left)} guess(es) left. Wrong guesses: #{formatting('bold_red', wrong_letters.join(', '))}.
        <>
        || This game's word is #{formatting('bold_blue', word)}
        <>

      INSTRUCTIONS
    end
  end

  def display_saved_games(saves)
    system 'clear'

    puts "\n<>"
    puts '|| Select your save.'
    puts '||'
    saves.each { |save| puts "|| #{formatting('bold', save)}" }
    puts "<>\n\n"
  end
end
