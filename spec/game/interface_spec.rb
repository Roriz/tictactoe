require 'game/interface'
require 'game/board'
require 'game/player'

RSpec.describe Game::Interface, '#Game::Interface' do
  describe '#render' do
    it 'should clear interface every render' do
      interface = Game::Interface.new
      board = Game::Board.new

      expect(interface).to receive(:system).with('clear')

      interface.render(board: board)
    end
    it 'should print empty board' do
      interface = Game::Interface.new
      board = Game::Board.new

      board_rendered = "0 | 1 | 2\n===+===+===\n"\
        "3 | 4 | 5\n===+===+===\n"\
        '6 | 7 | 8'

      expect(STDOUT).to receive(:puts).with(board_rendered)

      interface.render(board: board)
    end
    it 'should change every player on board for right marker' do
      interface = Game::Interface.new
      board = Game::Board.new

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

      interface.render(board: board)
    end
  end

  describe '#request_input' do
    it 'should print request message' do
      interface = Game::Interface.new

      gets_stub = double(
        chomp: '1'
      )

      expect($stdin).to receive(:gets).and_return(gets_stub)
      expect(STDOUT).to receive(:puts).with('Enter [0-8]:')

      interface.request_input
    end
    it 'should validate the value of the input' do
      interface = Game::Interface.new

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
  end
end
