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

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost],
    do: {game, tally(game)}

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: [],
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end
end
