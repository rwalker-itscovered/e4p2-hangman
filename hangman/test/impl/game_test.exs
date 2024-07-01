defmodule Impl.GameTest do
  use ExUnit.Case

  alias Hangman.Impl.Game

  test "new games returns structure" do
    game = Game.init_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new games returns correct word" do
    game = Game.init_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.init_game("wombat")
      game = Map.put(game, :game_state, state)

      {new_game, _tally} = Game.make_move(game, "x")

      assert new_game == game
    end
  end
end
