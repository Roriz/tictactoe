require 'tictactoe.rb'

RSpec.describe Game, '#Game' do
  it 'should initialize with board' do
    game = Game.new

    board = ('0'..'8').to_a

    expect(game.instance_variable_get(:@board)).to eq(board)
  end

  it 'should initialize with human and machine character' do
    game = Game.new

    expect(game.instance_variable_get(:@com)).to eq('X')
    expect(game.instance_variable_get(:@hum)).to eq('O')
  end

  it 'should render borad on start game' do
    game = Game.new

    board = " 0 | 1 | 2 \n===+===+===\n 3 | 4 | 5 \n===+===+===\n 6 | 7 | 8 \n"
    input_info = 'Enter [0-8]:'
    end_game = 'Game over'

    expect(STDOUT).to receive(:puts) { |arg|
      expect([board, input_info, end_game]).to include(arg)
      true
    }.thrice
    expect(game).to receive(:game_is_over).and_return(true)

    game.start_game
  end
end
