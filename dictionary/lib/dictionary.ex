defmodule Dictionary do
  alias Dictionary.Impl.WordList
  alias Dictionary.Type

  @spec start() :: Type.word_list()
  defdelegate start, to: WordList

  @spec random_word(Type.word_list()) :: Type.word()
  defdelegate random_word(word_list), to: WordList
end
