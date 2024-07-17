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
  def interact({_game, _tally = %{ game_state: :won }}) do
    IO.puts "Congrats, you won the game!"
  end

  def interact({_game, tally = %{ game_state: :lost }}) do
    IO.puts "Oh rats, you lost the game! The word was #{tally.letters |> Enum.join}"
  end

  def interact({game, tally}) do
    # feedback on current state
    # display current word
    # get next guess
    # make move
    interact({game, tally})
  end
end
