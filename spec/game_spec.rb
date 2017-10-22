require 'game.rb'

RSpec.describe Game::Game, '#Game' do
  it 'should initialize with interface class and board class' do
    game = Game::Game.new

    interface = game.instance_variable_get(:@interface)
    board = game.instance_variable_get(:@board)

    expect(interface).to be_an_instance_of(Game::Interface)
    expect(board).to be_an_instance_of(Game::Board)
  end

  it 'should initialize with default players' do
    game = Game::Game.new

    players = game.instance_variable_get(:@players)
    player1 = players.first
    player2 = players.last

    expect(players.length).to eq(2)
    expect(player1).to be_an_instance_of(Game::Player)
    expect(player1.human?).to eq(true)
    expect(player1.instance_variable_get(:@position)).to eq(:player_1)
    expect(player2).to be_an_instance_of(Game::Player)
    expect(player2.human?).to eq(false)
    expect(player2.instance_variable_get(:@position)).to eq(:player_2)
  end

  describe '#start_game' do
    it 'should render empty board' do
      game = Game::Game.new

      interface = game.instance_variable_get(:@interface)
      board = game.instance_variable_get(:@board)

      expect(interface).to receive(:render).with(board: board)
      expect(board).to receive(:empty_space?).and_return(false)

      game.start_game
    end

    it 'should request action for player1 at first' do
      game = Game::Game.new

      players = game.instance_variable_get(:@players)
      board = game.instance_variable_get(:@board)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(game).to receive(:player_action).with(player: players.first, opponent: players.last)

      game.start_game
    end

    it 'should request action for player2 at second' do
      game = Game::Game.new

      players = game.instance_variable_get(:@players)
      board = game.instance_variable_get(:@board)
      game.instance_variable_set(:@turn, 1)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(game).to receive(:player_action).with(player: players.last, opponent: players.first)

      game.start_game
    end

    it 'should request action, update borad and render board when player action' do
      game = Game::Game.new

      players = game.instance_variable_get(:@players)
      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)

      move = 0

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(game).to receive(:player_turn).with(player: players.first, opponent: players.last).and_return(move)
      expect(board).to receive(:update).with(action: move, player: players.first)
      expect(interface).to receive(:render).with(board: board).twice

      game.start_game
    end

    it 'should request human interaction when player is human' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(interface).to receive(:request_input).and_return(0)

      game.start_game
    end

    it 'should request best move when player is AI' do
      game = Game::Game.new

      player1 = Game::Player.new(
        type: :AI,
        position: :player_1
      )
      player2 = Game::Player.new(
        type: :AI,
        position: :player_2
      )

      board = game.instance_variable_get(:@board)
      game.instance_variable_set(:@players, [player1, player2])

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(player1).to receive(:best_move).with(board: board, opponent: player2).and_return(0)

      game.start_game
    end

    it 'should trigger end game when has winner' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)
      players = game.instance_variable_get(:@players)

      expect(game).to receive(:end_game)
      expect(board).to receive(:winner).and_return(players.first)

      game.start_game
    end

    it 'should trigger end game when not has empty space on board' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)

      expect(game).to receive(:end_game)
      expect(board).to receive(:empty_space?).and_return(false)

      game.start_game
    end
  end
end
