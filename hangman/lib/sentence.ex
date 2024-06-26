defmodule Sentence do
  @spec titlecase(String.t) :: String.t
  def titlecase(title) do
    title
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
