defmodule Dictionary do
  alias Dictionary.Impl.AgentWordList
  alias Dictionary.Type

  @spec start() :: Type.word_list()
  defdelegate start, to: AgentWordList

  @spec random_word(Type.word_list()) :: Type.word()
  defdelegate random_word(word_list), to: AgentWordList
end
