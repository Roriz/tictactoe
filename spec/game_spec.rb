require 'game.rb'

RSpec.describe Game::Game, '#Game' do
  it 'should initialize with interface class' do
    game = Game::Game.new

    interface = game.instance_variable_get(:@interface)

    expect(interface).to be_an_instance_of(Game::Interface)
  end

  describe '#start_game' do
    it 'should render empty board and request first input' do
      game = Game::Game.new

      interface = game.instance_variable_get(:@interface)

      expect(Game::Interface).to receive(:render)
      expect(interface).to receive(:request_input)

      game.start_game
    end
  end
end
