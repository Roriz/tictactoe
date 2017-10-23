module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the board
  class Board
    EMPTY = [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ].freeze

    WIN_POSITIONS = [
      # Row
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      # Line
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      # Diagonal
      [0, 4, 8],
      [2, 4, 6]
    ].freeze

    def initialize
      @board = EMPTY.dup
    end

    def update(action:, player:)
      @board[action] = player
    end

    def current_state
      @board
    end

    def empty_spaces
      @board.map.with_index { |e, i| e.nil? ? i : nil }.compact
    end

    def empty_space?
      !empty_spaces.empty?
    end

    def winner
      Board.winner(board: current_state)
    end

    def self.winner(board:)
      win_index = WIN_POSITIONS.find_index do |positions|
        markers = positions.map { |pos| board[pos] }.uniq

        markers.length == 1 && !markers.first.nil?
      end

      win_index ? board[WIN_POSITIONS[win_index].first] : nil
    end
  end
end
