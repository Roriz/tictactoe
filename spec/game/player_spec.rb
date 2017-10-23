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
        position: :player_1,
        type_of_ai: :hard
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2,
        type_of_ai: :hard
      )
      board = Game::Board.new

      expect(board).to receive(:empty_spaces).and_return(double(sample: 0))

      move = player.best_move(board: board, opponent: opponent)

      expect(move).to be 0
    end

    it 'should response move to win when the player can win on next turn' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1,
        type_of_ai: :hard
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2,
        type_of_ai: :hard
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
        position: :player_1,
        type_of_ai: :hard
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2,
        type_of_ai: :hard
      )
      board = Game::Board.new

      board_state = [opponent, opponent, nil, nil, nil, nil, nil, nil, nil]
      board.instance_variable_set(:@board, board_state)

      move = player.best_move(board: board, opponent: opponent)

      expect(move).to be 2
    end

    it 'should the response best move possible when IA is impossible' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1,
        type_of_ai: :impossible
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2,
        type_of_ai: :hard
      )
      board = Game::Board.new

      best_moves_in_order = [
        4,
        0, 2, 6, 8,
        1, 3, 5, 7
      ]

      expect(player).to receive(:reactive_action).and_return(nil).exactly(9).times

      board_state = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
      best_moves_in_order.each do |move|
        board.instance_variable_set(:@board, board_state)

        expect(player.best_move(board: board, opponent: opponent)).to be move
        board_state[move] = opponent
      end
    end

    it 'should the response worst move possible when IA is easy' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1,
        type_of_ai: :easy
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2,
        type_of_ai: :hard
      )
      board = Game::Board.new

      best_moves_in_order = [
        1, 3, 5, 7,
        0, 2, 6, 8,
        4
      ]

      expect(player).to receive(:reactive_action).and_return(nil).exactly(9).times

      board_state = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
      best_moves_in_order.each do |move|
        board.instance_variable_set(:@board, board_state)

        expect(player.best_move(board: board, opponent: opponent)).to be move
        board_state[move] = opponent
      end
    end

    it 'should replace move of opponent when IA is troll' do
      player = Game::Player.new(
        type: :AI,
        position: :player_1,
        type_of_ai: :troll
      )
      opponent = Game::Player.new(
        type: :AI,
        position: :player_2,
        type_of_ai: :hard
      )
      board = Game::Board.new

      board_state = [opponent, nil, nil, nil, nil, nil, nil, nil, nil]
      board.instance_variable_set(:@board, board_state)
      
      expect(player.best_move(board: board, opponent: opponent)).to be 0
    end
  end
end
