require 'game/player'

RSpec.describe Game::Player, '#Game' do
  describe '.initialize' do
    it 'should set type and position' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1
      )

      type = player.instance_variable_get(:@type)
      position = player.instance_variable_get(:@position)

      expect(type).to eq(:AI)
      expect(position).to eq(:player_1)
    end
  end

  describe '#human?' do
    it 'should response if player are human' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1
      )

      expect(player.human?).to eq false

      player.instance_variable_set(:@type, :HUMAN)

      expect(player.human?).to eq true
    end
  end

  describe '#position' do
    it 'should response enum based on player position' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1
      )

      expect(player.position).to eq :PLAYER1

      player.instance_variable_set(:@position, :player_2)

      expect(player.position).to eq :PLAYER2
    end
  end

  describe '#best_move' do
    it 'should response random action based on empty spaces of board' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2
      )
      board = Game::Board.new

      expect(board).to receive(:empty_spaces).and_return(double(sample: 0))

      move = player.best_move(board: board, opponent: opponent)

      expect(move).to be 0
    end

    it 'should response move to win when the player can win on next turn' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2
      )
      board = Game::Board.new

      board_state = [player, player, nil, nil, nil, nil, nil, nil, nil]
      board.instance_variable_set(:@board, board_state)

      move = player.best_move(board: board, opponent: opponent)

      expect(move).to be 2
    end

    it 'should the response move for not lose when the opponent can win on next turn' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2
      )
      board = Game::Board.new

      board_state = [opponent, opponent, nil, nil, nil, nil, nil, nil, nil]
      board.instance_variable_set(:@board, board_state)

      move = player.best_move(board: board, opponent: opponent)

      expect(move).to be 2
    end
  end
end
