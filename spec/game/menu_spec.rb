require 'game/menu'

RSpec.describe Game::Menu, '#Game::Menu' do
  DEFAULT_SETTINGS = {
    type_player_1: :HUMAN,
    type_player_2: :AI,
    type_of_ai: :hard
  }.freeze

  MOCKED_MENU = {
    label: 'mocked_label',
    options: [
      { id: '1', label: 'mocked_option_1' },
      { id: '2', label: 'mocked_option_2' },
      { id: '2', label: 'mocked_option_3' }
    ]
  }

  describe '.initialize' do
    it 'should set menu and settings' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      menu_hash = menu.instance_variable_get(:@menu)
      settings = menu.instance_variable_get(:@settings)
      previous = menu.instance_variable_get(:@previous)

      expect(menu_hash).to eq(MOCKED_MENU)
      expect(settings).to eq(DEFAULT_SETTINGS)
      expect(previous).to eq(nil)
    end
  end

  describe '#open' do
    it 'should print current settings, menu and request option' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return({})

      menu.open
    end
    it 'should run dynamically when option has `method` key' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:send).with(:mocked_method, 'mocked_id')
      expect(menu).to receive(:request_option).and_return(id: 'mocked_id', method: :mocked_method)

      menu.open
    end
  end

  describe '#open_ia_menu' do
    it 'should open new Menu current settings, menu and request option' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return(id: 'mocked_id', method: :open_ia_menu)

      menu_stubed = double(open: DEFAULT_SETTINGS)

      expect(Game::Menu).to receive(:new)
        .with(menu: Game::Menu::AI, settings: DEFAULT_SETTINGS, previous: menu)
        .and_return(menu_stubed)

      menu.open
    end
  end

  describe '#change_type_of_ai' do
    it 'should change settings :type_of_ai to id selected' do
      settings = DEFAULT_SETTINGS.dup
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: settings,
        previous: double(open: true)
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return(id: 'mocked_id', method: :change_type_of_ai)

      menu.open

      expect(settings[:type_of_ai]).to eq('mocked_id')
    end
  end

  describe '#open_ia_menu' do
    it 'should open new Menu current settings, menu and request option' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return(id: 'mocked_id', method: :open_players_menu)

      menu_stubed = double(open: DEFAULT_SETTINGS)

      expect(Game::Menu).to receive(:new)
        .with(menu: Game::Menu::PLAYERS, settings: DEFAULT_SETTINGS, previous: menu)
        .and_return(menu_stubed)

      menu.open
    end
  end

  describe '#change_type_of_ai' do
    it 'should change settings :type_of_ai to id selected' do
      settings = DEFAULT_SETTINGS.dup
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: settings,
        previous: double(open: true)
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return(id: { player_1: :MOCKED_1, player_2: :MOCKED_2 }, method: :change_players)

      menu.open

      expect(settings[:type_player_1]).to eq(:MOCKED_1)
      expect(settings[:type_player_2]).to eq(:MOCKED_2)
    end
  end

  describe '#settings_render' do
    it 'should print all settings' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return({})
      expect(I18n).to receive(:t).exactly(5).times

      menu.open
    end
    it 'should correctly print based on settings' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      settings_puts = [
        'current_settings',
        'player_is_human',
        'player_is_ai',
        'difficulty.hard',
        'ai_settings',
        "\n"
      ]

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return({})

      i18n_counter = 0
      expect(I18n).to receive(:t) { |msg|
        expect(msg).to eq(settings_puts[i18n_counter])
        i18n_counter += 1
      }.at_least(:once)

      menu.open
    end
    it 'should correctly print based on settings when has different settings' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: {
          type_player_1: :AI,
          type_player_2: :HUMAN,
          type_of_ai: :easy
        }
      )

      settings_puts = [
        'current_settings',
        'player_is_ai',
        'player_is_human',
        'difficulty.easy',
        'ai_settings',
        "\n"
      ]

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_option).and_return({})

      i18n_counter = 0
      expect(I18n).to receive(:t) { |msg|
        expect(msg).to eq(settings_puts[i18n_counter])
        i18n_counter += 1
      }.at_least(:once)

      menu.open
    end
  end

  describe '#print_options' do
    it 'should print all menu label and all options with i18n' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      options_prints = [
        'mocked_label',
        'mocked_option_1',
        'mocked_option_2',
        'mocked_option_3'
      ]

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:request_option).and_return({})
      i18n_counter = 0
      expect(I18n).to receive(:t) { |msg|
        expect(msg).to eq(options_prints[i18n_counter])
        i18n_counter += 1
      }.at_least(:once)

      menu.open
    end
    it 'should show the options with their indexes concatenated' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      options_prints = [
        'mocked_label',
        '1 - mocked_option_1',
        '2 - mocked_option_2',
        '3 - mocked_option_3'
      ]

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:request_option).and_return({})
      expect(I18n).to receive(:t) { |msg| msg }.at_least(:once)
      i18n_counter = 0
      expect(STDOUT).to receive(:puts) { |msg|
        expect(msg).to eq(options_prints[i18n_counter])
        i18n_counter += 1
      }.at_least(:once)

      menu.open
    end
  end

  describe '#request_option' do
    it 'should response option of menu based on user interaction' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect(menu).to receive(:request_input).and_return(1)

      option = menu.open

      expect(option).to eq(id: '1', label: 'mocked_option_1')
    end
    it 'should response option of menu based on user interaction' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      user_interaction = double(
        chomp: 1
      )

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect($stdin).to receive(:gets).and_return(user_interaction)

      option = menu.open

      expect(option).to eq(id: '1', label: 'mocked_option_1')
    end
    it 'should request another option when first is invalid' do
      menu = Game::Menu.new(
        menu: MOCKED_MENU,
        settings: DEFAULT_SETTINGS
      )

      user_interaction_right = double(chomp: 1)
      user_interaction_wrong = double(chomp: 999)

      expect(menu).to receive(:system).with('clear')
      expect(menu).to receive(:settings_render)
      expect(menu).to receive(:print_options)
      expect($stdin).to receive(:gets).and_return(user_interaction_wrong, user_interaction_right)
      expect(I18n).to receive(:t).with('erros.valid_option')

      option = menu.open

      expect(option).to eq(id: '1', label: 'mocked_option_1')
    end
  end
end
