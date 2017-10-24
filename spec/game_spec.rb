require 'game.rb'

RSpec.describe Game::Game, '#Game' do
  it 'should initialize with interface class and board class' do
    game = Game::Game.new

    interface = game.instance_variable_get(:@interface)
    board = game.instance_variable_get(:@board)

    expect(interface).to be_an_instance_of(Game::Interface)
    expect(board).to be_an_instance_of(Game::Board)
  end

  it 'should initialize with default settings' do
    game = Game::Game.new

    default_settings = {
      type_player_1: :HUMAN,
      type_player_2: :AI,
      type_of_ai: :hard
    }
    settings = game.instance_variable_get(:@settings)
    turn = game.instance_variable_get(:@turn)

    expect(settings).to eq(default_settings)
    expect(turn).to eq(0)
  end

  describe '#start_game' do
    it 'should render empty board' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)

      expect(interface).to receive(:render)
      expect(board).to receive(:empty_space?).and_return(false)
      expect(interface).to receive(:request_settings)

      game.start_game
    end

    it 'should apply settings for players' do
      game = Game::Game.new

      players = game.instance_variable_get(:@players)
      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)
      settings = game.instance_variable_get(:@settings)

      expect(board).to receive(:empty_space?).and_return(false)
      expect(interface).to receive(:request_settings)
      expect(players.first).to receive(:apply_settings).with(settings: settings)
      expect(players.last).to receive(:apply_settings).with(settings: settings)

      game.start_game
    end

    it 'should request action for player1 at first' do
      game = Game::Game.new

      players = game.instance_variable_get(:@players)
      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(game).to receive(:player_action).with(player: players.first, opponent: players.last)
      expect(interface).to receive(:request_settings)

      game.start_game
    end

    it 'should request action for player2 at second' do
      game = Game::Game.new

      players = game.instance_variable_get(:@players)
      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)
      game.instance_variable_set(:@turn, 1)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(game).to receive(:player_action).with(player: players.last, opponent: players.first)
      expect(interface).to receive(:request_settings)

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
      expect(interface).to receive(:render).twice
      expect(interface).to receive(:request_settings)

      game.start_game
    end

    it 'should request human interaction when player is human' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(interface).to receive(:request_move).and_return(0)
      expect(interface).to receive(:request_settings)

      game.start_game
    end

    it 'should request best move when player is AI' do
      game = Game::Game.new

      settings = {
        type_player_1: :AI,
        type_player_2: :AI,
        type_of_ai: :hard
      }
      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)
      players = game.instance_variable_get(:@players)
      game.instance_variable_set(:@settings, settings)

      expect(board).to receive(:empty_space?).and_return(true, false)
      expect(players.first).to receive(:best_move).and_return(0)
      expect(interface).to receive(:request_settings)

      game.start_game
    end

    it 'should trigger end game when has winner' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)
      players = game.instance_variable_get(:@players)
      interface = game.instance_variable_get(:@interface)

      expect(game).to receive(:end_game)
      expect(board).to receive(:winner).and_return(players.first)
      expect(interface).to receive(:request_settings)

      game.start_game
    end

    it 'should trigger end game when not has empty space on board' do
      game = Game::Game.new

      board = game.instance_variable_get(:@board)
      interface = game.instance_variable_get(:@interface)

      expect(game).to receive(:end_game)
      expect(board).to receive(:empty_space?).and_return(false)
      expect(interface).to receive(:request_settings)

      game.start_game
    end
  end
end
