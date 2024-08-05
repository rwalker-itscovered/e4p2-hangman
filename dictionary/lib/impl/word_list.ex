defmodule Dictionary.Impl.WordList do
  alias Dictionary.Type

  @spec start() :: Type.word_list()
  def start do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(Type.word_list()) :: Type.word()
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end
end
