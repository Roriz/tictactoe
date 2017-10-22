module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the interface
  class Interface
    MARKERS = {
      PLAYER1: 'P1',
      PLAYER2: 'P2'
    }.freeze

    ROW_SIZE = 3

    def initialize(board:)
      @board = board
    end

    def render
      system 'clear'
      puts board_render
    end

    def request_input
      puts 'Enter [0-8]:'

      input = $stdin.gets.chomp
      input = request_input unless valid_input?(input)

      input.to_i
    end

    def end_game
      puts 'Game over!'
    end

    private

    def valid_input?(input)
      not_a_number_valid = input_is_valid?(input)
      number_already_used = input_is_uniq?(input.to_i)

      puts 'Please enter a valid number' unless not_a_number_valid
      puts 'Please enter a number not yet used' if number_already_used

      not_a_number_valid && !number_already_used
    end

    def input_is_valid?(input)
      ('0'..'8').to_a.include?(input)
    end

    def input_is_uniq?(input)
      board_state = @board
                    .current_state
                    .map
                    .with_index { |state, index| state ? index : nil }
                    .compact
      board_state.include?(input)
    end

    def board_render
      board_markers
        .each_slice(ROW_SIZE)
        .map { |row| row.join(' | ') }
        .join("\n===+===+===\n")
    end

    def board_markers
      @board.current_state.map.with_index do |player, index|
        player ? MARKERS[player.position] : index
      end
    end
  end
end
