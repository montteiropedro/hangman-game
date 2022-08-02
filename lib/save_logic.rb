# frozen_string_literal: true

module SaveLogic
  def save_game
    puts formatting('bold_underline', "\nSAVE GAME")
    Dir.mkdir('saves') unless Dir.exist?('saves')

    @filename = @loaded_save_name.nil? ? generate_save_name : @loaded_save_name
    File.open("saves/#{@filename}", 'w') { |file| file.write to_yaml }

    puts display_game('saved_name')
  end

  def to_yaml
    YAML.dump({
      'difficulty' => @difficulty,
      'word' => @word,
      'wrong_letters' => @wrong_letters,
      'correct_letters' => @correct_letters,
      'available_letters' => @available_letters
    })
  end

  def generate_save_name
    print display_game('inform_save_name')
    input = gets.chomp.downcase

    return "#{input}.yaml" unless File.exist?("saves/#{input}.yaml")

    puts display_invalid('save_name')
    generate_save_name
  end

  def load_game
    display_saved_games(load_saves)
    selected_save = select_save

    return Game.new if selected_save == 'r'

    distribute_data(selected_save)
    puts display_game('loading')
    sleep(1)

    player_turns('load_game')
    end_game
  end

  def select_save
    print display_game('select_save_name')
    input = gets.chomp.downcase

    return input if input.match(/^r$/)

    if File.exist?("saves/#{input}.yaml")
      @loaded_save_name = "#{input}.yaml"
      return from_yaml(input)
    end

    puts display_invalid('selected_save')
    select_save
  end

  def from_yaml(filename)
    YAML.safe_load(File.read("saves/#{filename}.yaml"))
  end

  def load_saves
    saves = []
    Dir.entries('saves').each do |save|
      saves.push(save) if save.match(/[yaml]$/)
    end

    saves
  end

  def distribute_data(selected_save)
    @difficulty = selected_save['difficulty']
    @word = selected_save['word']
    @solution = word.split('')
    @available_letters = selected_save['available_letters']
    @correct_letters = selected_save['correct_letters']
    @wrong_letters = selected_save['wrong_letters']
  end

  def endgame_delete_save
    File.delete("saves/#{@loaded_save_name}")
  end
end
