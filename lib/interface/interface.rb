module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the interface
  class Interface
    MARKERS = {
      player1: 'X',
      player2: '0'
    }.freeze

    def initialize
      @board = ('0'..'8').to_a
    end

    def self.render
      frame = ' 0 | 1 | 2 \\n===+===+===\\n'\
      ' 3 | 4 | 5 \\n===+===+===\\n'\
      ' 6 | 7 | 8 \\n'

      puts frame

      frame
    end

    def request_input
      puts 'Enter [0-8]:'

      input = $stdin.gets.chomp
      request_input unless input_is_valid?(input)

      input
    end

    private

    def input_is_valid?(input)
      true
    end
  end
end
