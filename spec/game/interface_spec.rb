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
        '6 | 7 | 8'

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
        '6 | 7 | 8'

      expect(STDOUT).to receive(:puts).with(board_rendered)

      interface.render
    end
  end

  describe '#request_input' do
    it 'should print request message' do
      board = Game::Board.new
      interface = Game::Interface.new(board: board)

      gets_stub = double(
        chomp: '1'
      )

      expect($stdin).to receive(:gets).and_return(gets_stub)
      expect(STDOUT).to receive(:puts).with('Enter [0-8]:')

      interface.request_input
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
      expect(STDOUT).to receive(:puts) { |mgs|
        expect(['Enter [0-8]:', 'Please enter a valid number']).to include(mgs)
        true
      }.thrice

      interface.request_input
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
      expect(STDOUT).to receive(:puts) { |mgs|
        expect(['Enter [0-8]:', 'Please enter a number not yet used']).to include(mgs)
        true
      }.thrice

      interface.request_input
    end
  end
end
