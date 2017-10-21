require 'interface/interface'

RSpec.describe Game::Interface, '#Game' do
  it 'should initialize with board' do
    interface = Game::Interface.new

    board = ('0'..'8').to_a

    expect(interface.instance_variable_get(:@board)).to eq(board)
  end

  describe '#render' do
    it 'should response clear board' do
      interface = Game::Interface.new

      board = ' 0 | 1 | 2 \\n===+===+===\\n'\
        ' 3 | 4 | 5 \\n===+===+===\\n'\
        ' 6 | 7 | 8 \\n'

      expect(interface.render).to eq(board)
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
