defmodule Dictionary.Runtime.Server do

  @type t :: pid()

  alias Dictionary.Impl.WordList

  def start_link(), do: Agent.start_link(&WordList.start/0)

  def random_word(pid), do: Agent.get(pid, &WordList.random_word/1)
end
