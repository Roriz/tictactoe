require_relative 'game/interface'
require_relative 'game/player'
require_relative 'game/board'
require 'pry'

module Game
  # Game - class will maintain tictactoe and interface class
  class Game
    def initialize
      @players = [
        Player.new(
          type: :HUMAN,
          position: :player_1
        ),
        Player.new(
          type: :AI,
          position: :player_2
        )
      ]
      @board = Board.new
      @interface = Interface.new(board: @board)
      @turn = 0
    end

    def start_game
      @interface.render
      next_turn until @board.winner || !@board.empty_space?
      end_game
    end

    private

    def end_game
      @interface.end_game
    end

    def player1
      @players.first
    end

    def player2
      @players.last
    end

    def player1_turn?
      (@turn % @players.length).zero?
    end

    def next_turn
      player = player1_turn? ? player1 : player2
      opponent = player1_turn? ? player2 : player1

      player_action(player: player, opponent: opponent)
      @turn += 1
    end

    def player_action(player:, opponent:)
      action = player_turn(player: player, opponent: opponent)
      @board.update(action: action, player: player)
      @interface.render
    end

    def player_turn(player:, opponent:)
      if player.human?
        @interface.request_input
      else
        player.best_move(board: @board, opponent: opponent)
      end
    end
  end
end
