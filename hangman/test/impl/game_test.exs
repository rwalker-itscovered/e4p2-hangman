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

  test "a duplicate letter is reported" do
    game = Game.init_game("wombat")

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.init_game("wombat")
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")

    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognise a letter in the word" do
    game = Game.init_game("wombat")
    {_, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
  end

  test "we can win the game" do
    game = Game.init_game("wombat")
    {game, _} = Game.make_move(game, "m")
    {game, _} = Game.make_move(game, "c")
    {game, _} = Game.make_move(game, "o")
    {game, _} = Game.make_move(game, "w")
    {game, _} = Game.make_move(game, "t")
    {game, _} = Game.make_move(game, "b")
    {_, tally} = Game.make_move(game, "a")
    assert tally.game_state == :won
  end

  test "we decrement turns left on a bad guess" do
    game = Game.init_game("wombat")
    {_, tally} = Game.make_move(game, "x")
    assert tally.turns_left == 6
    assert tally.game_state == :bad_guess
  end

  test "we can lose a game" do
    game = Game.init_game("wxyz")
    {game, _} = Game.make_move(game, "a")
    {game, _} = Game.make_move(game, "b")
    {game, _} = Game.make_move(game, "c")
    {game, _} = Game.make_move(game, "d")
    {game, _} = Game.make_move(game, "e")
    {game, _} = Game.make_move(game, "f")
    {_game, tally} = Game.make_move(game, "g")
    assert tally.game_state == :lost
  end

  test "can handle a winning game" do
    [
      # guess state  turns  letters                    used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x",]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x",]],
      ["r", :bad_guess, 4, ["_", "e", "l", "l", "_"], ["a", "e", "l", "r", "x",]],
      ["o", :good_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "r", "x"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "h", "l", "o", "r", "x"]]
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a losing game" do
    [
      # guess state  turns  letters                    used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess, 4, ["_", "_", "_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess, 3, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :good_guess, 3, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["f", :bad_guess, 2, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f"]],
      ["g", :bad_guess, 1, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g"]],
      ["h", :good_guess, 1, ["h", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g", "h"]],
      ["i", :lost, 0, ["h", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "f", "g", "h", "i"]],

    ]
    |> test_sequence_of_moves()
  end

  test "should validate lowercase ascii" do
    game = Game.init_game("abc")
    { _, tally } = Game.make_move(game, "C")
    assert tally.game_state == :unacceptable_guess
  end

  defp test_sequence_of_moves(moves) do
    game = Game.init_game("hello")

    Enum.reduce(moves, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used
    game
  end
end
