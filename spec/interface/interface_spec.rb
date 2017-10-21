require 'interface/interface'

RSpec.describe Game::Interface, '#Game' do
  it 'should initialize with board' do
    interface = Game::Interface.new

    board = ('0'..'8').to_a

    expect(interface.instance_variable_get(:@board)).to eq(board)
  end

  describe '.render' do
    it 'should response clear board' do
      board = ' 0 | 1 | 2 \\n===+===+===\\n'\
        ' 3 | 4 | 5 \\n===+===+===\\n'\
        ' 6 | 7 | 8 \\n'

      expect(Game::Interface.render).to eq(board)
    end
  end
end
