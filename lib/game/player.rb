module Game
  # Class responsible for maintaining and manipulating
  # all interaction with the player
  class Player
    TYPES = {
      HUMAN: :HUMAN,
      AI: :AI
    }.freeze

    POSITIONS = {
      PLAYER1: :player_1,
      PLAYER2: :player_2
    }.freeze

    BOARD_BEST_ACTIONS = [
      3, 2, 3,
      2, 4, 2,
      3, 2, 3
    ].freeze

    def initialize(type:, position:, type_of_ai: nil)
      @type = type
      @position = position
      @type_of_ai = type_of_ai
    end

    def human?
      @type == TYPES[:HUMAN]
    end

    def position
      POSITIONS.invert[@position]
    end

    def best_move(board:, opponent:)
      board_state = board.current_state.dup

      best_move = board_state.find_index.with_index do |space, index|
        if space.nil?
          simulate_action(board: board_state.dup, opponent: opponent, action: index)
        else
          false
        end
      end

      best_move || board.empty_spaces.sample
    end

    def apply_settings(settings:)
      @type_of_ai = settings[:type_of_ai]
      @type = settings["type_#{@position}".to_sym]
    end

    private

    def simulate_action(board:, opponent:, action:)
      self_winner = simulate_winner(board: board, player: self, action: action)
      opponent_winner = simulate_winner(board: board, player: opponent, action: action)

      self_winner || opponent_winner
    end

    def simulate_winner(board:, player:, action:)
      board[action] = player
      Board.winner(board: board)
    end
  end
end
