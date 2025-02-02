defmodule Dictionary.Runtime.Server do

  @type t :: pid()

  @me __MODULE__

  use Agent

  alias Dictionary.Impl.WordList

  def start_link(_), do: Agent.start_link(&WordList.start/0, name: @me)


  def random_word() do
    # if :rand.uniform < 0.15 do
    #   Agent.get(@me, fn _ -> exit(:boom) end)
    # end
    Agent.get(@me, &WordList.random_word/1)
  end
end
