require 'game/interface'
require 'game/board'
require 'game/player'

RSpec.describe Game::Interface, '#Game::Interface' do
  describe '#render' do
    it 'should clear interface every render' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      expect(interface).to receive(:system).with('clear')

      interface.render
    end
    it 'should print empty board' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      board_rendered = "0 | 1 | 2\n===+===+===\n"\
        "3 | 4 | 5\n===+===+===\n"\
        "6 | 7 | 8\n"

      expect(STDOUT).to receive(:puts).with(board_rendered)

      interface.render
    end
    it 'should change every player on board for right marker' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      player1 = Game::Player.new(
        type: :AI,
        position: :player_1
      )
      player2 = Game::Player.new(
        type: :AI,
        position: :player_2
      )

      board.update(action: 0, player: player1)
      board.update(action: 1, player: player2)

      board_rendered = "P1 | P2 | 2\n===+===+===\n"\
        "3 | 4 | 5\n===+===+===\n"\
        "6 | 7 | 8\n"

      expect(STDOUT).to receive(:puts).with(board_rendered)

      interface.render
    end
  end

  describe '#request_move' do
    it 'should print request message' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      gets_stub = double(
        chomp: '1'
      )

      expect($stdin).to receive(:gets).and_return(gets_stub)
      expect(STDOUT).to receive(:puts).with('Enter [0-8]:')

      interface.request_move
    end
    it 'should validate type of the value of the input' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      gets_invalid_stub = double(
        chomp: 'a'
      )
      gets_valid_stub = double(
        chomp: '1'
      )

      expect($stdin).to receive(:gets).and_return(gets_invalid_stub, gets_valid_stub)
      expect(I18n).to receive(:t) { |mgs|
        expect(['request_input', 'errors.valid_number']).to include(mgs)
        true
      }.thrice

      interface.request_move
    end
    it 'should validate oneness of the value of the input' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board.update(action: 0, player: player)

      gets_invalid_stub = double(
        chomp: '0'
      )
      gets_valid_stub = double(
        chomp: '1'
      )

      expect($stdin).to receive(:gets).and_return(gets_invalid_stub, gets_valid_stub)
      expect(I18n).to receive(:t) { |mgs|
        expect(['request_input', 'errors.number_uniq']).to include(mgs)
        true
      }.thrice

      interface.request_move
    end
  end

  describe '#request_settings' do
    it 'should create new menu instance and show him' do
      default_settings = {
        type_player_1: :HUMAN,
        type_player_2: :AI,
        type_of_ai: :hard
      }
      new_settings = {
        type_player_1: :AI,
        type_player_2: :AI,
        type_of_ai: :hard
      }
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      menu_stubed = double(open: new_settings)

      expect(Game::Menu).to receive(:new)
        .with(menu: Game::Menu::MAIN, settings: default_settings)
        .and_return(menu_stubed)

      settings_requested = interface.request_settings(settings: default_settings)

      expect(settings_requested).to be(new_settings)
    end
  end
end
