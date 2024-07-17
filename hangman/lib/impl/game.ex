defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec init_game() :: t
  def init_game do
    init_game(Dictionary.random_word())
  end

  @spec init_game(String.t()) :: t
  def init_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_guess(game, guess, acceptable?(guess), MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  defp acceptable?(guess) do
    String.downcase(guess, :ascii) == guess
  end

  defp accept_guess(game, _guess, _acceptable = false, _already_used) do
    %{game | game_state: :unacceptable_guess}
  end

  defp accept_guess(game, _guess, _acceptable, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _acceptable, _alreaddy_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game, _bad_guess) do
    %{game | turns_left: game.turns_left - 1, game_state: :bad_guess}
    # turns left == 1 -> :lost | dec turns_left, :bad_guess
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp return_with_tally(game), do: {game, tally(game)}

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _), do: "_"
end
