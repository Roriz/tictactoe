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
      { base: 4, position: [4] },
      { base: 3, position: [0, 2, 6, 8] },
      { base: 2, position: [1, 3, 5, 7] }
    ].freeze

    AI_SETTINGS = {
      SELF_WINNER: :SELF_WINNER,
      SELF_OPPONENT: :SELF_OPPONENT,
      BEST_ACTION: :BEST_ACTION,
      RANDOM_ACTION: :RANDOM_ACTION,
      TROLL_ACTION: :TROLL_ACTION,
      WORST_ACTION: :WORST_ACTION
    }.freeze

    AI_ACTIONS = {
      easy: %i[WORST_ACTION],
      medium: %i[RANDOM_ACTION],
      hard: %i[RANDOM_ACTION SELF_WINNER SELF_OPPONENT],
      impossible: %i[BEST_ACTION SELF_WINNER SELF_OPPONENT],
      troll: %i[BEST_ACTION TROLL_ACTION]
    }.freeze

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

      reactive_action = reactive_action(board: board_state, opponent: opponent)
      best_action = nil
      best_action = board.empty_spaces.sample if action_for(:RANDOM_ACTION)
      best_action = best_action(board.empty_spaces) if action_for(:BEST_ACTION)
      best_action = worst_action(board.empty_spaces) if action_for(:WORST_ACTION)
      best_action = troll_action(board_state) if action_for(:TROLL_ACTION)

      reactive_action || best_action
    end

    def apply_settings(settings:)
      @type_of_ai = settings[:type_of_ai]
      @type = settings["type_#{@position}".to_sym]
    end

    private

    def troll_action(board)
      board.find_index { |pos| !pos.nil? && pos != self }
    end

    def worst_action(empty_spaces)
      action = BOARD_BEST_ACTIONS.reverse.find { |a| !(empty_spaces & a[:position]).empty? }

      action ? (empty_spaces & action[:position]).first : nil
    end

    def best_action(empty_spaces)
      action = BOARD_BEST_ACTIONS.find { |a| !(empty_spaces & a[:position]).empty? }

      action ? (empty_spaces & action[:position]).first : nil
    end

    def reactive_action(board:, opponent:)
      board.find_index.with_index do |space, index|
        if space.nil?
          simulate_action(board: board.dup, opponent: opponent, action: index)
        else
          false
        end
      end
    end

    def action_for(action)
      AI_ACTIONS[@type_of_ai].include?(action)
    end

    def simulate_action(board:, opponent:, action:)
      self_winner = nil
      opponent_winner = nil

      if action_for(:SELF_WINNER)
        self_winner = simulate_winner(board: board, player: self, action: action)
      end

      if action_for(:SELF_OPPONENT)
        opponent_winner = simulate_winner(board: board, player: opponent, action: action)
      end

      self_winner || opponent_winner
    end

    def simulate_winner(board:, player:, action:)
      board[action] = player
      Board.winner(board: board)
    end
  end
end
