require 'game/board'
require 'game/player'

RSpec.describe Game::Board, '#Game::Board' do
  describe '.initialize' do
    it 'should set empty board' do
      board = Game::Board.new

      state = board.instance_variable_get(:@board)

      expect(state).to eq([nil, nil, nil, nil, nil, nil, nil, nil, nil])
    end
  end

  describe '#update' do
    it 'should update right position with player instance' do
      board = Game::Board.new
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      state = board.instance_variable_get(:@board)

      board.update(action: 0, player: player)

      expect(state).to eq([player, nil, nil, nil, nil, nil, nil, nil, nil])
    end
  end

  describe '#current_state' do
    it 'should exposing the current state of the board' do
      board = Game::Board.new
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      expect(board.current_state).to eq([nil, nil, nil, nil, nil, nil, nil, nil, nil])

      board.update(action: 0, player: player)

      expect(board.current_state).to eq([player, nil, nil, nil, nil, nil, nil, nil, nil])
    end
  end

  describe '#empty_spaces' do
    it 'should response array of index for all empty spaces' do
      board = Game::Board.new
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      expect(board.empty_spaces).to eq((0..8).to_a)

      board.update(action: 0, player: player)

      expect(board.empty_spaces).to eq((1..8).to_a)
    end
  end

  describe '#empty_space?' do
    it 'should response if has any empty space on current board' do
      board = Game::Board.new
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      expect(board.empty_space?).to be true

      board.update(action: 0, player: player)
      board.update(action: 1, player: player)
      board.update(action: 2, player: player)
      board.update(action: 3, player: player)
      board.update(action: 4, player: player)
      board.update(action: 5, player: player)
      board.update(action: 6, player: player)
      board.update(action: 7, player: player)
      board.update(action: 8, player: player)

      expect(board.empty_space?).to be false
    end
  end

  describe '#winner' do
    it 'should request winner from Board class with current state' do
      board = Game::Board.new

      expect(Game::Board).to receive(:winner)
        .with(board: board.current_state).and_return(0)

      board.winner
    end
  end

  describe '.winner' do
    it 'should response player winner when player are on [0,1,2] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [player, player, player, nil, nil, nil, nil, nil, nil]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [3,4,5] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [nil, nil, nil, player, player, player, nil, nil, nil]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [6, 7, 8] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [nil, nil, nil, nil, nil, nil, player, player, player]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [0, 3, 6] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [player, nil, nil, player, nil, nil, player, nil, nil]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [1, 4, 7] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [nil, player, nil, nil, player, nil, nil, player, nil]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [2, 5, 8] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [nil, nil, player, nil, nil, player, nil, nil, player]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [0, 4, 8] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [player, nil, nil, nil, player, nil, nil, nil, player]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response player winner when player are on [2, 4, 6] positions' do
      player = Game::Player.new(type: :HUMAN, position: :player_1)

      board = [nil, nil, player, nil, player, nil, player, nil, nil]

      expect(Game::Board.winner(board: board)).to be player
    end

    it 'should response nil when are two differents players on [0, 1, 2] positions' do
      player1 = Game::Player.new(type: :HUMAN, position: :player_1)
      player2 = Game::Player.new(type: :HUMAN, position: :player_2)

      board = [player1, player1, player2, nil, nil, nil, nil, nil, nil]

      expect(Game::Board.winner(board: board)).to be nil
    end

    it 'should response nil when board are empty' do
      board = [nil, nil, nil, nil, nil, nil, nil, nil, nil]

      expect(Game::Board.winner(board: board)).to be nil
    end
  end
end
