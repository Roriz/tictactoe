require_relative './config'

module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the menu options
  class Menu
    MAIN = {
      label: I18n.t('menu.main_label'),
      options: [
        { id: 'next', label: I18n.t('menu.start_game') },
        { id: 'config_ia', label: I18n.t('menu.config_ia'), method: :open_ia_menu },
      ]
    }.freeze

    AI = {
      label: I18n.t('menu.ia_label'),
      options: [
        { id: :easy, label: I18n.t('difficulty.easy'), method: :change_type_of_ai },
        { id: :medium, label: I18n.t('difficulty.medium'), method: :change_type_of_ai },
        { id: :hard, label: I18n.t('difficulty.hard'), method: :change_type_of_ai },
        { id: :impossible, label: I18n.t('difficulty.impossible'), method: :change_type_of_ai },
        { id: :troll, label: I18n.t('difficulty.troll'), method: :change_type_of_ai }
      ]
    }.freeze

    def initialize(menu:, settings:, previous: nil)
      @menu = menu
      @settings = settings
      @previous = previous
    end

    def show
      system 'clear'

      settings_render
      puts "\n"
      print_options
      option = request_option

      send(option[:method], option[:id]) if option.key?(:method)
    end

    private

    def open_ia_menu(_id)
      menu = Menu.new(menu: AI, settings: @settings, previous: self)
      menu.show
    end

    def change_type_of_ai(id)
      @settings[:type_of_ai] = id
      @previous.show
    end

    def settings_render
      puts I18n.t('current_settings')
      puts I18n.t("player_is_#{@settings[:type_player_1].to_s.downcase}", n: 1)
      puts I18n.t("player_is_#{@settings[:type_player_2].to_s.downcase}", n: 2)
      puts I18n.t('ai_settings', difficulty: I18n.t("difficulty.#{@settings[:type_of_ai]}"))
    end

    def print_options
      puts @menu[:label]

      @menu[:options].each.with_index do |option, index|
        puts "#{index + 1} - #{option[:label]}"
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
