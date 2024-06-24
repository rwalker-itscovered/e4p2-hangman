defmodule Hangman do
  def new_game(word) do
    %{
      state: %{secret_word: word, status: :playing},
      tally: %{guesses: [], wrong: 0, hint: get_hint(word, [])}
    }
  end

  def make_move(
        %{
          state: %{secret_word: word, status: status},
          tally: %{guesses: guesses, wrong: wrong, hint: _}
        },
        guess
      )
      when status == :playing do
    word
    |> String.contains?(guess)
    |> update_game(word, guesses, wrong, guess)
  end

  def make_move(_, _) do
    "Go home, its over"
  end

  def update_game(is_right, word, guesses, wrong, guess) when is_right do
    updated_guesses = guesses ++ [guess]
    updated_hint = get_hint(word, updated_guesses)
    updated_status = game_win?(updated_hint)

    %{
        state: %{secret_word: word, status: updated_status},
        tally: %{guesses: updated_guesses, wrong: wrong, hint: get_hint(word, updated_guesses)}
      }
  end

  def update_game(_, word, guesses, wrong, guess) do
    updated_guesses = guesses ++ [guess]
    updated_wrong = wrong + 1
    updated_status = too_many_errors?(wrong)

    %{
      state: %{secret_word: word, status: updated_status},
      tally: %{
        guesses: updated_guesses,
        wrong: updated_wrong,
        hint: get_hint(word, updated_guesses)
      }
    }
  end

  def game_win?(updated_hint) do
    if String.contains?(updated_hint, "_") do
      :playing
    else
      :won
    end
  end

  def too_many_errors?(wrong) when wrong >= 6, do: :lost

  def too_many_errors?(_), do: :playing

  def get_hint(word, guesses) do
    word
    |> String.split("", trim: true)
    |> Enum.reduce("", fn letter, acc ->
      if Enum.any?(guesses, fn guess -> guess == letter end) do
        acc <> letter
      else
        acc <> "_"
      end
    end)
  end
end
