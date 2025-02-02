defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()

  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    interact({game, tally})
  end

  # @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used | :unacceptable_guess

  @spec interact(state) :: :ok
  def interact({_game, tally = %{game_state: :won}}) do
    IO.puts("Congrats, you won the game! You had #{tally.turns_left} turns left")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Oh rats, you lost the game! The word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    Hangman.make_move(game, get_guess())
    |> interact()
  end

  # @type state ::  :initializing | :good_guess | :bad_guess | :already_used | :unacceptable_guess

  def feedback_for(tally = %{game_state: :initializing}) do
    [
      "\nWelcome to the Hangman Game.\n",
      "----------------------------\n",
      "I'm thinking of a #{tally.letters |> length} letter word\n"
    ]
  end

  def feedback_for(%{game_state: :good_guess}), do: "Good guess!"
  def feedback_for(%{game_state: :bad_guess}), do: "Oh no, that wasn't right!"
  def feedback_for(%{game_state: :unacceptable_guess}), do: "Please only use lowercase letters"

  def feedback_for(%{game_state: :already_used}),
    do: "You already used that one, I won't count it this time..."

  def current_word(tally) do
    [
      "Word so far: #{tally.letters |> Enum.join(" ")}",
      IO.ANSI.green() <> "   (turns left: ",
      IO.ANSI.blue() <> "#{tally.turns_left |> to_string}",
      IO.ANSI.green() <> "   letters used: ",
      IO.ANSI.yellow() <> "#{tally.used |> Enum.join(",")}",
      IO.ANSI.green() <> ")" <> IO.ANSI.reset() <> "\n"
    ]
  end

  def get_guess do
    IO.gets("Next Letter: ")
    |> String.trim
    |> String.downcase
  end
end
