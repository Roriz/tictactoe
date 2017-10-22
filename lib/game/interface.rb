module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the interface
  class Interface
    MARKERS = {
      PLAYER1: 'P1',
      PLAYER2: 'P2'
    }.freeze

    ROW_SIZE = 3

    def render(board:)
      system 'clear'
      puts board_render(board: board)
    end

    def request_input
      puts 'Enter [0-8]:'

      input = $stdin.gets.chomp
      unless input_is_valid?(input)
        puts 'Please enter a valid number'
        input = request_input
      end

      input.to_i
    end

    def end_game
      puts 'Game over!'
    end

    private

    def input_is_valid?(input)
      ('0'..'8').to_a.include?(input)
    end

    def board_render(board:)
      board_markers(board: board)
        .each_slice(ROW_SIZE)
        .map { |row| row.join(' | ') }
        .join("\n===+===+===\n")
    end

    def board_markers(board:)
      board.current_state.map.with_index do |player, index|
        player ? MARKERS[player.position] : index
      end
    end
  end
end
