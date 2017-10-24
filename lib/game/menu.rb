module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the menu options
  class Menu
    MAIN = {
      label: 'menu.main_label',
      options: [
        { id: 'next', label: 'menu.start_game' },
        { id: 'config_ia', label: 'menu.config_ia', method: :open_ia_menu },
        { id: 'config_players', label: 'menu.config_players', method: :open_players_menu },
      ]
    }.freeze

    AI = {
      label: 'menu.ia_label',
      options: [
        { id: :easy, label: 'difficulty.easy', method: :change_type_of_ai },
        { id: :medium, label: 'difficulty.medium', method: :change_type_of_ai },
        { id: :hard, label: 'difficulty.hard', method: :change_type_of_ai },
        { id: :impossible, label: 'difficulty.impossible', method: :change_type_of_ai },
        { id: :troll, label: 'difficulty.troll', method: :change_type_of_ai }
      ]
    }.freeze

    PLAYERS = {
      label: 'menu.players_label',
      options: [
        { id: { player_1: :HUMAN, player_2: :HUMAN }, label: 'players_vs_player', method: :change_players },
        { id: { player_1: :HUMAN, player_2: :AI }, label: 'players_vs_ai', method: :change_players },
        { id: { player_1: :AI, player_2: :HUMAN }, label: 'ai_vs_player', method: :change_players },
        { id: { player_1: :AI, player_2: :AI }, label: 'ai_vs_ai', method: :change_players },
      ]
    }.freeze

    def initialize(menu:, settings:, previous: nil)
      @menu = menu
      @settings = settings
      @previous = previous
    end

    def open
      system 'clear'

      settings_render
      print_options
      option = request_option

      send(option[:method], option[:id]) if option.key?(:method)

      option
    end

    private

    def open_players_menu(_id)
      menu = Menu.new(menu: PLAYERS, settings: @settings, previous: self)
      menu.open
    end

    def change_players(config)
      @settings[:type_player_1] = config[:player_1]
      @settings[:type_player_2] = config[:player_2]
      @previous.open
    end

    def open_ia_menu(_id)
      menu = Menu.new(menu: AI, settings: @settings, previous: self)
      menu.open
    end

    def change_type_of_ai(id)
      @settings[:type_of_ai] = id
      @previous.open
    end

    def settings_render
      puts I18n.t('current_settings')
      puts I18n.t("player_is_#{@settings[:type_player_1].to_s.downcase}", n: 1)
      puts I18n.t("player_is_#{@settings[:type_player_2].to_s.downcase}", n: 2)
      puts I18n.t('ai_settings', difficulty: I18n.t("difficulty.#{@settings[:type_of_ai]}"))
      puts "\n"
    end

    def print_options
      puts I18n.t(@menu[:label])

      @menu[:options].each.with_index do |option, index|
        puts "#{index + 1} - #{I18n.t(option[:label])}"
      end
    end

    def request_option
      @menu[:options][request_input - 1]
    end

    def request_input
      input = $stdin.gets.chomp
      unless valid_option?(input.to_i)
        puts I18n.t('erros.valid_option')
        input = request_input
      end
      input.to_i
    end

    def valid_option?(input)
      (1..@menu[:options].length).to_a.include?(input)
    end
  end
end
