defmodule Dictionary.Impl.AgentWordList do
  alias Dictionary.Type

  @spec start() :: Type.word_list()
  def start do
    {:ok, pid } = Agent.start(fn ->
      "assets/words.txt"
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
    end)
    pid
  end

  @spec random_word(Type.word_list()) :: Type.word()
  def random_word(word_list) do
    Agent.get(word_list, fn words -> words |> Enum.random end)
  end
end
